# == Schema Information
#
# Table name: holdings
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  entity_id             :integer          not null
#  quantity              :integer          default("0")
#  value                 :decimal(20, )    default("0")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  investment_instrument :string(100)
#  investor_id           :integer          not null
#  holding_type          :string(15)       not null
#

class Holding < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :entity
  belongs_to :investor

  validates :quantity, presence: true

  before_save :set_type
  def set_type
    self.holding_type = user_id.present? ? "Employee" : "Investor"
  end

  # Only update the investment if its coming from an employee of a holding company
  after_create :update_investment, if: proc { |h| h.holding_type == "Employee" }
  before_destroy :reduce_investment, if: proc { |h| h.holding_type == "Employee" }

  def update_investment
    investment = entity.investments.where(employee_holdings: true, investment_instrument: investment_instrument).first
    unless investment
      employee_investor = Investor.for(user, entity).first
      investment = Investment.new(investment_type: "Employee Holdings", investment_instrument: investment_instrument,
                                  category: "Employee", investee_entity_id: entity.id, investor_id: employee_investor.id,
                                  employee_holdings: true, quantity: 0, currency: entity.currency)
    end

    investment.quantity += quantity
    investment.save
    investment.update_percentage_holdings
  end

  def reduce_investment
    investment = entity.investments.where(employee_holdings: true, investment_instrument: investment_instrument).first
    investment.quantity -= quantity
    investment.save
    investment.update_percentage_holdings
  end

  def active_secondary_sale
    entity.secondary_sales.where("secondary_sales.start_date <= ? and secondary_sales.end_date >= ?",
                                 Time.zone.today, Time.zone.today).first
  end
end
