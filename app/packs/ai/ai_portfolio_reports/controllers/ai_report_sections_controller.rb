class AiReportSectionsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def update
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @section = @report.ai_report_sections.find(params[:id])

    # Handle plain_content from textarea
    @section.content = params[:ai_report_section][:plain_content] if params[:ai_report_section][:plain_content].present?

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

    # Add attribution
    attributed_content = "#{content_to_add}\n\n-- Added from AI at #{Time.current.strftime('%H:%M')} --\n\n"

    # Append to section content
    current_content = @section.content&.body&.to_plain_text || ""
    @section.content = current_content + attributed_content

    @section.save!

    render json: { success: true, content: @section.content.body.to_plain_text }
  end
end
