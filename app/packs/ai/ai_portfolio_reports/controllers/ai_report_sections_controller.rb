class AiReportSectionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:regenerate] # Skip CSRF for AJAX
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def update
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])

    # Handle content from contenteditable
    @section.content_html = params[:ai_report_section][:content] if params[:ai_report_section][:content].present?

    @section.reviewed = true

    if @section.save
      redirect_to ai_portfolio_report_path(@report, section_id: @section.id), flash: { ai_notice: 'Section saved and marked as reviewed.' }
    else
      redirect_to ai_portfolio_report_path(@report, section_id: @section.id), alert: 'Failed to save section.'
    end
  end

  def toggle_web_search
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])

    # Toggle the flag
    @section.web_search_enabled = !@section.web_search_enabled

    if @section.save
      # If this is the current section being viewed, regenerate content
      if params[:regenerate] == 'true'
        company_name = @report.portfolio_company&.name || "TechVenture Inc."
        
        # Call Python backend to regenerate content with new web_search setting
        response = PythonBackendClient.generate_section(
          section_type: @section.section_type,
          company_name: company_name,
          web_search_enabled: @section.web_search_enabled
        )

        if response.success?
          data = response.parsed_response
          @section.content_html = data['content']
          @section.save
        end
      end

      render json: {
        success: true,
        web_search_enabled: @section.web_search_enabled,
        message: @section.web_search_enabled ? 'Web search enabled' : 'Web search disabled'
      }
    else
      render json: { success: false, error: 'Failed to toggle web search' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :internal_server_error
  end

  def add_content
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])
    content_to_add = params[:content]

    # Add attribution with HTML formatting
    attributed_content = "#{content_to_add}<p><em>-- Added from AI at #{Time.current.strftime('%H:%M')} --</em></p>"

    # Append to section content (preserve HTML)
    current_content = @section.content_html || ""
    @section.content_html = current_content + attributed_content

    @section.save!

    render json: { success: true, content: @section.content_html }
  end

  def regenerate
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])

    user_prompt = params[:prompt]
    current_content = params[:current_content]
    section_type = params[:section_type]
    web_search_enabled = params[:web_search_enabled] == 'true'  # ? Should be there from Phase 1
  

    begin
      if section_type == "Custom Charts"
        Rails.logger.info "=== Custom Charts Action ==="
        
        generator = ChartSectionGenerator.new(report: @report, section: @section)
        
        if user_prompt.present?
          # USER PROVIDED PROMPT - Add a new chart based on prompt
          Rails.logger.info "Adding chart based on prompt: #{user_prompt}"
          
          new_chart_html = generator.add_chart_from_prompt(user_prompt: user_prompt)
          
          # Append new chart to existing content
          if current_content.present?
            refined_content = current_content + new_chart_html
          else
            refined_content = new_chart_html
          end
          
        else
          # NO PROMPT - Regenerate all charts (clear and create 3 default)
          Rails.logger.info "Regenerating all default charts"
          
          @section.update(agent_chart_ids: [])
          refined_content = generator.generate_charts_html
        end
        
        Rails.logger.info "Charts in section: #{@section.reload.agent_chart_ids.count}"
        
      else
        # Text sections - use PortfolioReportAgent
        Rails.logger.info "=== Refining #{section_type} ==="
        rails.logger.info "Web search enabled: #{web_search_enabled}"
        
        agent = SupportAgent.find_or_create_by!(
          agent_type: 'PortfolioReportAgent',
          entity_id: @report.analyst.entity_id
        ) do |a|
          a.name = 'Portfolio Report Generator'
          a.enabled = true
        end
        
        result = PortfolioReportAgent.call(
          support_agent_id: agent.id,
          target: @section,
          action: 'refine',
          document_folder_path: "/tmp/test_documents",
          current_content: current_content,
          user_prompt: user_prompt,
          web_search_enabled: web_search_enabled  # ? ADD THIS
        )
        
        if result.success?
          refined_content = @section.reload.content_html
        else
          return render json: { success: false, error: result[:error] || 'Refinement failed' }, status: :unprocessable_entity
        end
      end
      
      render json: { success: true, content: refined_content }
      
    rescue StandardError => e
      Rails.logger.error "Regenerate error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { success: false, error: e.message }, status: :internal_server_error
    end
  end
end