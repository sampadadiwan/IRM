class VestedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    EsopPool.where("excercised_quantity < allocated_quantity").each do |pool|
      pool.holdings.each do |holding|
        holding.vested_quantity = (holding.quantity * holding.allowed_percentage / 100).round(0)
        holding.save
      end

      pool.vested_quantity = pool.holdings.sum(:vested_quantity)
      pool.save
    end
  end
end
