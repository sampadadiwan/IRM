class AiReportSection < ApplicationRecord
  belongs_to :ai_portfolio_report
  has_rich_text :content

  validates :section_type, presence: true

  def completed?
    content.present? && content.body.to_plain_text.present?
  end
end
