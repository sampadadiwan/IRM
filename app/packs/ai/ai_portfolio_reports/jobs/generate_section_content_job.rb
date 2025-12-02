class GenerateSectionContentJob < ApplicationJob
  queue_as :default

  def perform(report_id)
    report = AiPortfolioReport.find(report_id)
    company_name = report.portfolio_company&.name || "TechVenture Inc."

    Rails.logger.info "=== Starting content generation for report #{report_id} ==="

    report.ai_report_sections.each do |section|
      # SKIP ALL SECTIONS EXCEPT CUSTOM CHARTS
      # next unless section.section_type == "Custom Charts"

      # Skip if already has content
      next if section.content_html.present?

      begin
        Rails.logger.info "Generating content for: #{section.section_type}"

        # Call Python backend to generate content
        response = PythonBackendClient.generate_section(
          section_type: section.section_type,
          company_name: company_name
        )

        if response.success?
          data = response.parsed_response
          content_html = data['content']

          Rails.logger.info "Content received (#{content_html.length} chars): #{content_html[0..100]}..."

          section.content_html = content_html
          if section.save
            Rails.logger.info "Saved content for #{section.section_type}"
            Rails.logger.info "Content HTML: #{section.content_html[0..100]}"
          else
            Rails.logger.error "Failed to save: #{section.errors.full_messages}"
          end

          # Verify it saved
          section.reload
          Rails.logger.info "Content saved: #{section.content_html.present?}"

          Rails.logger.info "Generated content for section: #{section.section_type}"
        else
          Rails.logger.error "Failed to generate content for #{section.section_type}: #{response.code}"
        end
      rescue StandardError => e
        Rails.logger.error "Error generating section #{section.section_type}: #{e.message}"
      end

      # Small delay to avoid rate limiting
      sleep(1)
    end

    Rails.logger.info "=== Completed content generation for report #{report_id} ==="
  end
end
