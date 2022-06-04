class VestedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # We need to check for vesting only in pools where excercise is not complete
    OptionPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.not_investors.each do |holding|
        vested_quantity = holding.compute_vested_quantity
        holding.vested_quantity = vested_quantity

        HoldingAction.create(entity: holding.entity, holding:, action: "Vesting", quantity: vested_quantity) if holding.vested_quantity_changed?

        # Check if the Options have lapsed
        if holding.lapsed?
          lapsed_quantity = holding.compute_lapsed_quantity
          holding.lapsed = true
          holding.lapsed_quantity = lapsed_quantity
          HoldingAction.create(entity: holding.entity, holding:, action: "Lapsed", quantity: lapsed_quantity)
        end

        holding.save
      end
    end
  end
end
