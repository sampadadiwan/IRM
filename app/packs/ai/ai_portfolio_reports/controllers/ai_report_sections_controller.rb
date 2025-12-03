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

    @section.web_search_enabled = !@section.web_search_enabled

    if @section.save
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

    # Call Python backend to regenerate with refinement
    response = PythonBackendClient.refine_section(
      section_type: section_type,
      current_content: current_content,
      user_prompt: user_prompt,
      web_search_enabled: @section.web_search_enabled
    )

    if response.success?
      data = response.parsed_response
      refined_content = data['content']

      render json: { success: true, content: refined_content }
    else
      render json: { success: false, error: 'Failed to regenerate content' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :internal_server_error
  end
end
