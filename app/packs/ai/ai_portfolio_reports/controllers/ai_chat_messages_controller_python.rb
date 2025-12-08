class AiChatMessagesController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @report = AiPortfolioReport.find(params[:ai_portfolio_report_id])
    @chat_session = @report.ai_chat_sessions.find_by(id: params[:chat_session_id]) || @report.ai_chat_sessions.first
    @current_section = @report.ai_report_sections.find(params[:section_id])

    # Save user message
    @chat_session.ai_chat_messages.create!(
      role: 'user',
      content: params[:message]
    )

    # Call Python backend
    begin
      response = PythonBackendClient.chat(
        message: params[:message],
        section: @current_section.section_type,
        web_search_enabled: @current_section.web_search_enabled
      )

      if response.success?
        data = response.parsed_response

        # Save AI response
        ai_message = @chat_session.ai_chat_messages.create!(
          role: 'assistant',
          content: data['response'],
          metadata: {
            'sources' => data['sources'],
            'confidence' => data['confidence']
          }
        )

        render json: {
          success: true,
          message_id: ai_message.id,
          response: data['response'],
          sources: data['sources']
        }
      else
        render json: { success: false, error: 'Backend error' }, status: :service_unavailable
      end
    rescue StandardError => e
      Rails.logger.error "Python backend error: #{e.message}"
      render json: { success: false, error: e.message }, status: :internal_server_error
    end
  end
end
