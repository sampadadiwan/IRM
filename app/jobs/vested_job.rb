class VestedJob < ApplicationJob
  queue_as :default
  LAPSE_WARNING_DAYS = [30, 20, 10, 5].freeze
  def perform(*_args)
    # We need to check for vesting only in pools where excercise is not complete
    OptionPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.not_investors.each do |holding|
        unless holding.manual_vesting
          vested_quantity = holding.compute_vested_quantity
          holding.vested_quantity = vested_quantity

          HoldingAction.create(entity: holding.entity, holding:, action: "Vesting", quantity: vested_quantity) if holding.vested_quantity_changed?
        end

        check_lapsed(holding)
        holding.save
      end

      pool.save
    end
  end

  def check_lapsed(holding)
    # Check if the Options have lapsed
    if holding.lapsed?
      lapsed_quantity = holding.compute_lapsed_quantity
      holding.lapsed = true
      holding.lapsed_quantity = lapsed_quantity
      HoldingAction.create(entity: holding.entity, holding:, action: "Lapsed", quantity: lapsed_quantity)
      holding.notify_lapsed

    elsif LAPSE_WARNING_DAYS.include?(holding.days_to_lapse)
      holding.notify_lapse_upcoming
    end
  end
end
