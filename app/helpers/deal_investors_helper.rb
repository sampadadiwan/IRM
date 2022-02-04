module DealInvestorsHelper
    STATUS_BADGE_MAP={"Active" => "bg-success", "Pending" => "bg-warning", "Declined" => "bg-danger"}
    def status_badge(di)
        STATUS_BADGE_MAP[di.status]        
    end
end
