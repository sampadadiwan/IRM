module StatisticsHelper
  def investment_by_dilution(entity)
    diluted = Investment.where(investee_entity_id: entity.id, investment_instrument: %w[Equity Preferred])
                        .joins(:investor).includes(:investor).group_by { |i| i.investor.investor_name }
                        .map { |k, v| [k, v.inject(0) { |sum, e| sum + e.percentage_holding }] }
    undiluted = Investment.where(investee_entity_id: entity.id, investment_instrument: %w[Equity Preferred])
                          .joins(:investor).includes(:investor).group_by { |i| i.investor.investor_name }
                          .map { |k, v| [k, v.inject(0) { |sum, e| sum + e.diluted_percentage }] }
    data = [
      { name: "Diluted", data: diluted },
      { name: "Undiluted", data: undiluted }
    ]
    column_chart data,
                 #  stacked: false,
                 prefix: "%"
  end

  def investment_by_intrument(entity)
    column_chart Investment.where(investee_entity_id: entity.id)
                           .group_by(&:investment_instrument)
                           .map { |k, v| [k, v.inject(0) { |sum, e| sum + (e.amount_cents / 100) }] }
                           .map { |k, v| [k, v] },
                 prefix: "#{entity.currency}:"
  end

  def funding_rounds_chart(entity)
    column_chart FundingRound.where(entity_id: entity.id).order(id: :asc)
                             .map { |f| ["#{f.name} - #{l(f.created_at.to_date)}", f.amount_raised_cents / 100] },
                 prefix: "#{entity.currency}:"
  end

  def investment_by_investor(entity)
    # pie_chart Investment.where(investee_entity_id: entity.id)
    #                     .joins(:investor).includes(:investor).group("investors.investor_name").sum(:initial_value),

    # We cant use the DB, as values are encrypted
    column_chart Investment.where(investee_entity_id: entity.id)
                           .joins(:investor).includes(:investor).group_by { |i| i.investor.investor_name }
                           .map { |k, v| [k, v.inject(0) { |sum, e| sum + (e.amount_cents / 100) }] },
                 stacked: true,
                 prefix: "#{entity.currency}:"
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
    column_chart group_by_month
  end

  def investor_interaction(entity)
    investors = Investor.where("investee_entity_id =? and last_interaction_date > ?", entity.id, Time.zone.today - 6.months)
                        .group('MONTH(last_interaction_date)')
    group_by_month = investors.count.sort.to_h.transform_keys { |k| I18n.t('date.month_names')[k] }
    column_chart group_by_month
  end
end
