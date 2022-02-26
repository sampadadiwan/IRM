class Holding < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :entity
  belongs_to :investor

  before_save :set_type
  def set_type
    self.holding_type = user_id.present? ? "Employee" : "Investor"
  end

  # Only update the investment if its coming from an employee of a holding company
  after_create :update_investment, if: proc { |h| h.holding_type == "Employee" }
  def update_investment
    investment = entity.investments.where(employee_holdings: true).first
    unless investment
      employee_investor = Investor.for(user, entity).first
      investment = Investment.new(investment_type: "Employee Holdings", investment_instrument: "Equity",
                                  category: "Employee", investee_entity_id: entity.id, investor_id: employee_investor.id,
                                  employee_holdings: true, quantity: 0)
    end

    investment.quantity += quantity
    investment.save
    investment.update_percentage_holdings
  end

  def active_secondary_sale
    entity.secondary_sales.where("secondary_sales.start_date <= ? and secondary_sales.end_date >= ?",
                                 Time.zone.today, Time.zone.today).first
  end
end
