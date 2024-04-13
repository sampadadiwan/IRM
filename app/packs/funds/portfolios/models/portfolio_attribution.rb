class PortfolioAttribution < ApplicationRecord
  include Trackable.new
  belongs_to :entity
  belongs_to :fund
  belongs_to :sold_pi, class_name: "PortfolioInvestment"
  belongs_to :bought_pi, class_name: "PortfolioInvestment", touch: true
  before_save :compute_cost_of_sold_cents

  monetize :cost_of_sold_cents, with_currency: ->(i) { i.fund.currency }

  after_commit :update_cost_of_sold, unless: :destroyed?

  counter_culture :bought_pi, column_name: 'sold_quantity', delta_column: 'quantity'
  # counter_culture :bought_pi, column_name: 'cost_of_sold_cents', delta_column: 'cost_of_sold_cents'
  counter_culture :sold_pi, column_name: 'cost_of_sold_cents', delta_column: 'cost_of_sold_cents'
  counter_culture %i[sold_pi aggregate_portfolio_investment], column_name: 'cost_of_sold_cents', delta_column: 'cost_of_sold_cents'

  # Compute the cost_of_sold for the sold_pi
  def update_cost_of_sold
    # This is required to trigger PI.compute_fmv
    PortfolioInvestmentUpdate.call(portfolio_investment: sold_pi.reload)
    PortfolioInvestmentUpdate.call(portfolio_investment: bought_pi.reload)
  end

  def compute_cost_of_sold_cents
    self.cost_of_sold_cents = quantity * bought_pi.cost_cents
  end

  # This is so that the bought_pi net_quantity is updated
  after_destroy_commit ->(pa) { PortfolioInvestmentUpdate.call(portfolio_investment: bought_pi.reload) unless pa.destroyed? }

  def gain
    Money.new((sold_pi.price_per_share_cents - bought_pi.price_per_share_cents) * quantity.abs, fund.currency)
  end
end
