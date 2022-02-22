class Holding < ApplicationRecord
  belongs_to :user
  belongs_to :entity

  after_create :update_investment
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
end
