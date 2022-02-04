module DealActivitiesHelper
    def activity_color(deal_activity)
        if deal_activity.completed 
            "btn-outline-success" 
        elsif deal_activity.by_date < Date.today
            "btn-outline-danger"
        elsif deal_activity.by_date == Date.today    
            "btn-outline-warning"
        else
            "btn-outline-secondary"
        end
    end
end
