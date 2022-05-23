class VestedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # We need to check for vesting only in pools where excercise is not complete
    EsopPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.each do |holding|
        holding.vested_quantity = (holding.quantity * holding.allowed_percentage / 100).round(0)
        Rails.logger.debug { "holding.quantity: #{holding.quantity}, holding.allowed_percentage: #{holding.allowed_percentage}, holding.vested_quantity: #{holding.vested_quantity}" }
        # Check if the ESOPs have lapsed
        if holding.lapsed?
          holding.lapsed = true
          holding.lapsed_quantity = holding.compute_lapsed_quantity
        end
        holding.save
      end

      pool.vested_quantity = pool.holdings.sum(:vested_quantity)
      pool.lapsed_quantity = pool.holdings.sum(:lapsed_quantity)
      pool.save
    end
  end
end
