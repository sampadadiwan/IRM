class AggregateInvestment < ApplicationRecord
  belongs_to :entity
  belongs_to :funding_round
  belongs_to :investor

  # Investments which belong to the Actual scenario are the real ones
  # All others are imaginary scenarios for planning and dont add to the real
  belongs_to :scenario

  def update_percentage
    entity.aggregate_investments.each do |ai|
      eq = (entity.equity + entity.preferred)
      ai.percentage = 100.0 * (ai.equity + ai.preferred) / eq if eq.positive?

      eq_op = (entity.equity + entity.preferred + entity.options)
      ai.full_diluted_percentage = 100.0 * (ai.equity + ai.preferred + ai.options) / eq_op if eq_op.positive?

      ai.save
    end
  end
end
