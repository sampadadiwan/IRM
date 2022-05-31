class HoldingApproveJob < ApplicationJob
  queue_as :default

  def perform(type, id)
    Chewy.strategy(:sidekiq) do
      Rails.logger.debug { "HoldingApproveJob: #{type} #{id}" }

      case type
      when "OptionPool"
        count = Holding.not_approved.where(option_pool_id: id).update(approved: true)
      when "FundingRound"
        count = Holding.not_approved.where(funding_round_id: id).update(approved: true)
      when "Entity"
        count = Holding.not_approved.where(entity: id).update(approved: true)
      end

      Rails.logger.debug { "HoldingApproveJob: #{type} #{id}. Update #{count} records." }
    end
  end
end
