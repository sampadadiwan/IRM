class HoldingSummary
  def initialize(params, user)
    @params = params
    @user = user
    # This is an employee - so find his parent company

    entity_id = params[:entity_id].presence || user.employee_parent_entity&.id
    @entity = Entity.find(entity_id)
  end

  def estimated_profits(price_growth)
    profits = Money.new(0, @entity.currency)

    @holdings ||= @user.holdings.options.where(entity_id: @entity.id).includes(option_pool: :entity, entity: :valuations)

    @holdings.each do |holding|
      per_share_value = holding.entity.valuations.last.per_share_value
      profits += ((per_share_value * price_growth) - holding.option_pool.excercise_price) * holding.quantity
    end

    profits
  end

  def employee_summary
    last_valuation = @entity.valuations.last&.per_share_value
    # Get the price growth from the UI
    price_growth = @params[:price_growth].present? ? @params[:price_growth].to_f : 3
    # Get the tax rate from the UI
    tax_rate = @params[:tax_rate] ? @params[:tax_rate].to_f : 30

    if last_valuation
      estimated_profit = estimated_profits(price_growth)
      estimated_taxes = estimated_profit * tax_rate / 100
      total_value_cents = @user.holdings.options.where(entity_id: @entity.id).sum(:value_cents) / 100
      esop_value = Money.new(total_value_cents, @entity.currency)

      cost_neutral_sale = (estimated_taxes + esop_value) / (last_valuation * price_growth)
    else
      estimated_taxes = Money.new(0, @entity.currency)
      estimated_profit = Money.new(0, @entity.currency)
      cost_neutral_sale = 0
      last_valuation = Money.new(0, @entity.currency)
    end

    [price_growth, tax_rate, estimated_taxes, estimated_profit, cost_neutral_sale, last_valuation]
  end

  def projected_profits
    # This sets which holdings the employee is seeing
    [2, 3, 4, 5, 6, 7, 8, 9, 10].map do |price_growth|
      [price_growth, estimated_profits(price_growth).cents / 100]
    end
  end
end
