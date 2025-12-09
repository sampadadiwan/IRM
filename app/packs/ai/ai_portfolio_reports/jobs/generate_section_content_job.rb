class GenerateSectionContentJob < ApplicationJob
  queue_as :default
  
  def perform(report_id)
  report = AiPortfolioReport.find(report_id)
  
  Rails.logger.info "=== Starting generation for report #{report_id} ==="
  
  report.ai_report_sections.each do |section|
    # Skip if already has content
    next if section.content_html.present?
    
    # TEMPORARY: Only generate Custom Charts for testing
    next unless section.section_type == "Custom Charts"
    
    begin
      Rails.logger.info "Generating: #{section.section_type}"
      
      # SPECIAL HANDLING: Custom Charts section uses Rails service
      if section.section_type == "Custom Charts"
        generate_charts_section(report, section)
        # IMPORTANT: Skip to next section, don't call PortfolioReportAgent!
        next  # ? ADD THIS - exits the loop iteration
      else
        # All other sections use PortfolioReportAgent
        generate_text_section(report, section)
      end
      
    rescue StandardError => e
      Rails.logger.error "Error: #{section.section_type}: #{e.message}"
    end
    
    sleep(2)  # Rate limiting
  end
  
  Rails.logger.info "=== Completed generation for report #{report_id} ==="
end

private

# Generate charts using Rails ChartSectionGenerator
def generate_charts_section(report, section)
  Rails.logger.info "  ? Using Rails ChartSectionGenerator"
  
  generator = ChartSectionGenerator.new(report: report, section: section)
  html = generator.generate_charts_html
  
  section.update(content_html: html)
  
  Rails.logger.info "  ? Generated #{section.agent_chart_ids.count} charts"
end

# Generate text using PortfolioReportAgent
def generate_text_section(report, section)
  Rails.logger.info "  ? Using PortfolioReportAgent"
  
  # Find or create PortfolioReportAgent
  agent = SupportAgent.find_or_create_by!(
    agent_type: 'PortfolioReportAgent',
    entity_id: report.analyst.entity_id
  ) do |a|
    a.name = 'Portfolio Report Generator'
    a.enabled = true
  end
  
  # Call PortfolioReportAgent
  result = PortfolioReportAgent.call(
    support_agent_id: agent.id,
    target: section,
    action: 'generate',
    document_folder_path: "/tmp/test_documents"
  )
  
  if result.success?
    Rails.logger.info "  ? Generated #{section.section_type}"
  else
    Rails.logger.error "  ? Failed #{section.section_type}: #{result[:error]}"
  end
end
end