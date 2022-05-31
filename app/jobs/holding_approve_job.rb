class HoldingApproveJob < ApplicationJob
  queue_as :default

  def perform(type, id)
    Chewy.strategy(:sidekiq) do
      Rails.logger.debug { "HoldingApproveJob: #{type} #{id}" }

      case type
      when "OptionPool"
        holdings = Holding.not_approved.where(option_pool_id: id)
      when "FundingRound"
        holdings = Holding.not_approved.where(funding_round_id: id)
      when "Entity"
        holdings = Holding.not_approved.where(entity: id)
      end

      holdings.each do |holding|
        ApproveHolding.call(holding: holding)
      end

      Rails.logger.debug { "HoldingApproveJob: #{type} #{id}. Update #{holdings.count} records." }
    end
  end
end
