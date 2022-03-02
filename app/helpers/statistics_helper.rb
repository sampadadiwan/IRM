module StatisticsHelper
  def investment_by_investment_type(entity)
    bar_chart Investment.where(investee_entity_id: entity.id).group(:investment_type).sum(:amount),
              prefix: '₹'
  end

  def investment_by_intrument(entity)
    bar_chart Investment.where(investee_entity_id: entity.id).group(:investment_instrument).sum(:amount),
              #   xtitle: "Investment Amount",
              #   ytitle: "Type",
              prefix: '₹'
  end

  def investment_by_investor(entity)
    # pie_chart Investment.where(investee_entity_id: entity.id)
    #                     .joins(:investor).includes(:investor).group("investors.investor_name").sum(:initial_value),

    # We cant use the DB, as values are encrypted
    pie_chart Investment.where(investee_entity_id: entity.id)
                        .joins(:investor).includes(:investor).group_by { |i| i.investor.investor_name }
                        .map { |k, v| [k, v.inject(0) { |sum, e| sum + e.amount }] },
              #   xtitle: "Investment Amount",
              #   ytitle: "Type",
              donut: true,
              prefix: '₹'
  end

  def count_by_investor(entity)
    pie_chart Investor.where(investee_entity_id: entity.id)
                      .group("category").count,
              #   xtitle: "Investment Amount",
              #   ytitle: "Type",
              donut: true  
  end

  def notes_by_month(entity)
    notes = Note.where(entity_id: entity.id)
                .group('MONTH(created_at)')
    group_by_month = notes.count.sort.to_h.transform_keys { |k| I18n.t('date.month_names')[k] }
    bar_chart group_by_month
  end

  def investor_interaction(entity)
    investors = Investor.where("investee_entity_id =? and last_interaction_date > ?", entity.id, Time.zone.today - 6.months)
                        .group('MONTH(last_interaction_date)')
    group_by_month = investors.count.sort.to_h.transform_keys { |k| I18n.t('date.month_names')[k] }
    bar_chart group_by_month
  end
end
