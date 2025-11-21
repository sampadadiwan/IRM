class AiReportSection < ApplicationRecord
  belongs_to :ai_portfolio_report
  # Remove this line:
  # has_rich_text :content

  validates :section_type, presence: true

  def completed?
    content_html.present?
  end
end
