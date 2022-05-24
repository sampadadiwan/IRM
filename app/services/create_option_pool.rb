class CreateOptionPool < Patterns::Service
  def initialize(option_pool)
    @option_pool = option_pool
  end

  def call
    OptionPool.transaction do
      setup_funding_round
      option_pool.save
    end
    option_pool
  end

  private

  attr_reader :option_pool

  def setup_funding_round
    option_pool.funding_round = FundingRound.create(name: option_pool.name,
                                                    currency: option_pool.entity.currency, entity_id: option_pool.entity_id,
                                                    status: "Open")
  end
end
