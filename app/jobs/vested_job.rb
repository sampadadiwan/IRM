class VestedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # We need to check for vesting only in pools where excercise is not complete
    OptionPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.not_investors.each do |holding|
        unless holding.manual_vesting
          vested_quantity = holding.compute_vested_quantity
          holding.vested_quantity = vested_quantity

          if holding.vested_quantity_changed?
            HoldingAction.create(entity: holding.entity, holding:, action: "Vesting", quantity: vested_quantity)
            holding.save
          end
        end

        LapseHolding.call(holding:)
      end

      pool.save
    end
  end
end
