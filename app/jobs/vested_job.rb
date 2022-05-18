class VestedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # We need to check for vesting only in pools where excercise is not complete
    EsopPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.each do |holding|
        holding.vested_quantity = (holding.quantity * holding.allowed_percentage / 100).round(0)
        # Check if the ESOPs have lapsed
        if holding.lapsed?
          holding.lapsed = true
          pool.lapsed_quantity += holding.lapsed_quantity
        end
        holding.save
      end

      pool.vested_quantity = pool.holdings.sum(:vested_quantity)
      pool.save
    end
  end
end
