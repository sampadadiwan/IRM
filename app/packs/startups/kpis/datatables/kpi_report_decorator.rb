class KpiReportDecorator < ApplicationDecorator
  delegate_all

  def entity_name
    if object.portfolio_company_id.present?
      h.link_to(object.portfolio_company.investor_name, h.kpi_reports_path(portfolio_company_id: object.portfolio_company_id, grid_view: true))
    else
      h.link_to(object.entity.name, h.kpi_reports_path(entity_id: object.entity_id, grid_view: true))
    end
  end

  def dt_actions
    links = []
    links << h.link_to('Show', h.kpi_report_path(object), class: "btn btn-outline-primary")
    links << h.link_to('Edit', h.edit_kpi_report_path(object), class: "btn btn-outline-success") if h.policy(object).edit?
    h.safe_join(links, '')
  end
end
