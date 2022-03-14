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
  INVESTMENT_FOR = %w[Employee Founder].freeze

  belongs_to :user, optional: true
  belongs_to :entity
  belongs_to :investor
  belongs_to :investment, optional: true
  counter_culture :investment, column_name: proc { |h| INVESTMENT_FOR.include?(h.holding_type) ? 'quantity' : nil }, delta_column: 'quantity'

  validates :quantity, :holding_type, presence: true

  # before_save :set_type
  # def set_type
  #   self.holding_type ||= user_id.present? ? "Employee" : "Investor"
  # end

  # Only update the investment if its coming from an employee of a holding company
  before_save :update_investment, if: proc { |h| INVESTMENT_FOR.include?(h.holding_type) }
  after_save ->(holding) { holding.investment.update_percentage_holdings }, if: proc { |h| INVESTMENT_FOR.include?(h.holding_type) }

  def update_investment
    self.investment = entity.investments.where(employee_holdings: true,
                                               investment_instrument: investment_instrument,
                                               category: holding_type).first
    if investment.nil?
      # Rails.logger.debug { "Updating investment for #{to_json}" }
      employee_investor = Investor.for(user, entity).first
      self.investment = Investment.create(investment_type: "#{holding_type} Holdings",
                                          investment_instrument: investment_instrument,
                                          category: holding_type, investee_entity_id: entity.id,
                                          investor_id: employee_investor.id, employee_holdings: true,
                                          quantity: 0, price: 0, currency: entity.currency)
    end
  end

  def active_secondary_sale
    entity.secondary_sales.where("secondary_sales.start_date <= ? and secondary_sales.end_date >= ?",
                                 Time.zone.today, Time.zone.today).first
  end

  def holder_name
    user ? user.full_name : investor.investor_name
  end
end
