# == Schema Information
#
# Table name: funding_rounds
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  total_amount_cents         :decimal(20, 2)   default("0.00")
#  currency                   :string(5)
#  pre_money_valuation_cents  :decimal(20, 2)   default("0.00")
#  post_money_valuation_cents :decimal(20, 2)   default("0.00")
#  entity_id                  :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  amount_raised_cents        :decimal(20, 2)   default("0.00")
#  status                     :string(255)      default("Open")
#  closed_on                  :date
#

class FundingRound < ApplicationRecord
  monetize  :total_amount_cents, :pre_money_valuation_cents,
            :amount_raised_cents, :post_money_valuation_cents,
            with_model_currency: :currency

  belongs_to :entity
  has_many :investments, dependent: :destroy

  validates :name, :total_amount_cents, :currency, :pre_money_valuation_cents, :status, presence: true

  scope :open, -> { where(status: "Open") }

  before_save :compute_post_money
  def compute_post_money
    self.post_money_valuation = pre_money_valuation + amount_raised
    self.closed_on = Time.zone.today if status_changed? && status == "Closed"
    # case status
    # when "Open"
    #   self.post_money_valuation = pre_money_valuation + total_amount
    # when "Closed"
    #   self.post_money_valuation = pre_money_valuation + amount_raised
    # end
  end
end
