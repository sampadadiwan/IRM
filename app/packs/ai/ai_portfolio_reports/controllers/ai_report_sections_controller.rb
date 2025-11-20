class AiReportSectionsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def update
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])

    # Handle content from rich text area
    if params[:ai_report_section][:content].present?
      @section.content = params[:ai_report_section][:content]
    end

    # Mark as reviewed when saved
    @section.reviewed = true

    if @section.save
      redirect_to ai_portfolio_report_path(@report, section_id: @section.id), notice: 'Section saved and marked as reviewed.'
    else
      redirect_to ai_portfolio_report_path(@report, section_id: @section.id), alert: 'Failed to save section.'
    end
  end

  def add_content
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])
    content_to_add = params[:content]

    # Add attribution with HTML formatting
    attributed_content = "#{content_to_add}<p><em>-- Added from AI at #{Time.current.strftime('%H:%M')} --</em></p>"

    # Append to section content (preserve HTML)
    current_content = @section.content&.body&.to_html || ""
    @section.content = current_content + attributed_content

    @section.save!

    render json: { success: true, content: @section.content.body.to_html }
  end
end
