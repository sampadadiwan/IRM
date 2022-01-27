module StatisticsHelper
    def investment_by_investment_type(entity)
      bar_chart Investment.where(investee_entity_id: entity.id).group(:investment_type).sum(:initial_value), 
      prefix: '₹'
    end


    def investment_by_intrument(entity)
        bar_chart Investment.where(investee_entity_id: entity.id).group(:investment_instrument).sum(:initial_value), 
        #   xtitle: "Investment Amount",
        #   ytitle: "Type",
        prefix: '₹'
    end

    def investment_by_investor(entity)
        pie_chart Investment.where(investee_entity_id: entity.id).
        joins(:investor).includes(:investor).group("investors.investor_name").sum(:initial_value), 
      #   xtitle: "Investment Amount",
      #   ytitle: "Type",
        donut: true,
        prefix: '₹'
    end

    def count_by_investor(entity)
        pie_chart Investor.where(investee_entity_id: entity.id).
        group("category").count, 
      #   xtitle: "Investment Amount",
      #   ytitle: "Type",
        donut: true,
        prefix: '₹'
    end
end