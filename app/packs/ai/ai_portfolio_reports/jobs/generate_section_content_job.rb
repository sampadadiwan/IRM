class GenerateSectionContentJob < ApplicationJob
  queue_as :default

  def perform(report_id)
    report = AiPortfolioReport.find(report_id)
    company_name = report.portfolio_company&.name || "TechVenture Inc."

    Rails.logger.info "=== Starting content generation for report #{report_id} ==="

    report.ai_report_sections.each do |section|
      # Skip if already has content
      next if section.content.present? && section.content.body.present?

      begin
        Rails.logger.info "Generating content for: #{section.section_type}"

        # Call Python backend to generate content
        response = PythonBackendClient.generate_section(
          section_type: section.section_type,
          company_name: company_name
        )

        if response.success?
          data = response.parsed_response
          content = data['content']

          Rails.logger.info "Content received (#{content.length} chars): #{content[0..100]}..."

          # ActionText needs the content assigned properly
          content_text = data['content']
          section.content = content_text
          if section.save
            Rails.logger.info "Saved content for #{section.section_type}"
            Rails.logger.info "Plain text: #{section.content.body.to_plain_text[0..100]}"
          else
            Rails.logger.error "Failed to save: #{section.errors.full_messages}"
          end

          # Verify it saved
          section.reload
          Rails.logger.info "Content saved: #{section.content.present?}"
          Rails.logger.info "Content body: #{section.content.body.present?}"

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
