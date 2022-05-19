module HoldingsHelper
  def employee_summary
    # This sets which holdings the employee is seeing
    entity_id = params[:entity_id].presence || current_user.holdings.first.entity_id
    entity = Entity.find(entity_id)

    # Get the price growth from the UI
    price_growth = params[:price_growth].present? ? params[:price_growth].to_f : 3
    estimated_profit = Holding.estimated_profits(price_growth, current_user, entity)

    # Get the tax rate from the UI
    tax_rate = params[:tax_rate] ? params[:tax_rate].to_f : 30

    estimated_taxes = estimated_profit * tax_rate / 100
    total_value_cents = current_user.holdings.options.where(entity_id: entity.id).sum(:value_cents) / 100
    esop_value = Money.new(total_value_cents, entity.currency)

    last_valuation = entity.valuations.last.per_share_value

    cost_neutral_sale = (estimated_taxes + esop_value) / (last_valuation * price_growth)

    [price_growth, tax_rate, estimated_taxes, estimated_profit, cost_neutral_sale]
  end
end
