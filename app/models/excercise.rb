class Excercise < ApplicationRecord
  belongs_to :entity
  belongs_to :holding
  belongs_to :user
  belongs_to :esop_pool

  monetize :price_cents, :amount_cents, :tax_cents, with_currency: ->(i) { i.entity.currency }

  counter_culture :esop_pool,
                  column_name: proc { |e| e.approved && e.holding.update_esop_pool? ? 'excercised_quantity' : nil }, delta_column: 'quantity'

  counter_culture :holding,
                  column_name: proc { |e| e.approved ? 'excercised_quantity' : nil },
                  delta_column: 'quantity'
end
