class FundingRound < ApplicationRecord
  monetize  :total_amount_cents, :pre_money_valuation_cents,
            :amount_raised_cents, :post_money_valuation_cents,
            with_model_currency: :currency

  belongs_to :entity
  has_many :investments, dependent: :destroy

  scope :open, -> {where(status:"Open")}

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
