class VestedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # We need to check for vesting only in pools where excercise is not complete
    OptionPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.each do |holding|
        # Check if the Options have lapsed
        if holding.lapsed?
          holding.lapsed = true
          holding.lapsed_quantity = holding.compute_lapsed_quantity
        end
        holding.save
      end
    end
  end
end
