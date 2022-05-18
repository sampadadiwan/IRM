class Valuation < ApplicationRecord
  belongs_to :entity
  has_many_attached :reports, service: :amazon

  monetize :pre_money_valuation_cents, :per_share_value_cents,
           with_currency: ->(s) { s.entity.currency }
end
