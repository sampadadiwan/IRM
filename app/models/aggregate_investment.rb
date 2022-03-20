class AggregateInvestment < ApplicationRecord
  belongs_to :entity
  belongs_to :funding_round
  belongs_to :investor

  def update_percentage_holdings
    entity.aggregate_investments.each do |ai|
      eq = (entity.equity + entity.preferred)
      ai.percentage = 100.0 * (ai.equity + ai.preferred) / eq if eq.positive?

      eq_op = (entity.equity + entity.preferred + entity.option)
      ai.full_diluted_percentage = 100.0 * (ai.equity + ai.preferred + ai.option) / eq_op if eq_op.positive?

      ai.save
    end
  end
end
