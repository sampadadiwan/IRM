class AiPortfolioReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = policy_scope(AiPortfolioReport).order(created_at: :desc)
  end

  def new
    @report = AiPortfolioReport.new
    authorize @report
  end

  def create
    @report = AiPortfolioReport.new(report_params)
    @report.analyst_id = current_user.id
    authorize @report

    if @report.save
      @report.ai_chat_sessions.create!(analyst_id: current_user.id)

      # Generate AI content for all sections in background
      GenerateSectionContentJob.perform_later(@report.id)

      redirect_to @report, notice: 'Report created! AI is generating content for all sections (this may take a minute)...'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @report
    @current_section = @report.ai_report_sections.find_by(id: params[:section_id]) ||
                       @report.ai_report_sections.order(:order_index).first
    @chat_session = @report.ai_chat_sessions.first || @report.ai_chat_sessions.create!(analyst_id: current_user.id)
  end

  def destroy
    authorize @report
    @report.destroy
    redirect_to ai_portfolio_reports_path, notice: 'Report deleted.'
  end

  private

  def set_report
    @report = AiPortfolioReport.find(params[:id])
  end

  def report_params
    params.require(:ai_portfolio_report).permit(:portfolio_company_id, :report_date)
  end
end
