class GenerateSectionContentJob < ApplicationJob
  queue_as :default
  
  def perform(report_id)
    report = AiPortfolioReport.find(report_id)
    
    Rails.logger.info "=== Starting Rails agent generation for report #{report_id} ==="
    
    # Find or create PortfolioReportAgent
    agent = SupportAgent.find_or_create_by!(
      agent_type: 'PortfolioReportAgent',
      entity_id: report.analyst.entity_id
    ) do |a|
      a.name = 'Portfolio Report Generator'
      a.enabled = true
    end
    
    report.ai_report_sections.each do |section|
      # Skip if already has content
      next if section.content_html.present?
      
      begin
        Rails.logger.info "Generating: #{section.section_type}"
        
        # Call PortfolioReportAgent
        result = PortfolioReportAgent.call(
          support_agent_id: agent.id,
          target: section,
          action: 'generate',
          document_folder_path: "/tmp/test_documents"  # TODO: Use actual document folder
        )
        
        if result.success?
          Rails.logger.info "? Generated #{section.section_type}"
        else
          Rails.logger.error "? Failed #{section.section_type}: #{result[:error]}"
        end
        
      rescue StandardError => e
        Rails.logger.error "Error: #{section.section_type}: #{e.message}"
      end
      
      sleep(2)  # Rate limiting
    end
    
    Rails.logger.info "=== Completed generation for report #{report_id} ==="
  end
end