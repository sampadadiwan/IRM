class AiReportSection < ApplicationRecord
  belongs_to :ai_portfolio_report
  
  
  validates :section_type, presence: true

  def completed?
    content_html.present?
  end
  
  # Get all associated charts
  def agent_charts
    return [] if agent_chart_ids.blank?
    AgentChart.where(id: agent_chart_ids)
  end
  
  # Add a chart to this section
  def add_chart(chart)
    self.agent_chart_ids ||= []
    self.agent_chart_ids << chart.id unless agent_chart_ids.include?(chart.id)
    save
  end
  
  # Check if this is a charts section
  def charts_section?
    section_type == "Custom Charts"
  end
end