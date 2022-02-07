module DealInvestorsHelper
  STATUS_BADGE_MAP = { "Active" => "bg-success", "Pending" => "bg-warning", "Declined" => "bg-danger" }.freeze
  def status_badge(di)
    STATUS_BADGE_MAP[di.status]
  end
end
