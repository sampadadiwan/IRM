class AllocationJob < ApplicationJob
  queue_as :default

  def perform(secondary_sale_id)
    Chewy.strategy(:sidekiq) do
      secondary_sale = SecondarySale.find(secondary_sale_id)
      secondary_sale.allocation_status = "InProgress"
      secondary_sale.save

      begin
        init(secondary_sale)
        update_offers(secondary_sale)
        update_sale(secondary_sale)
        secondary_sale.allocation_status = "Completed"
      rescue StandardError => e
        ExceptionNotifier.notify_exception(e)
        logger.error "Error: #{e.message}"
        logger.error e.backtrace.join("\n")
        secondary_sale.allocation_status = "Error"
      end

      secondary_sale.save
    end
  end

  def init(secondary_sale)
    clean_up(secondary_sale)

    total_offered_quantity = secondary_sale.offers.approved.sum(:quantity)
    total_interest_quantity = secondary_sale.interests.eligible(secondary_sale).sum(:quantity)

    secondary_sale.allocation_percentage = total_offered_quantity.positive? ? (total_interest_quantity * 1.0 / total_offered_quantity).round(4) : 0
    logger.debug "total_offered_quantity = #{total_offered_quantity},
                  total_interest_quantity = #{total_interest_quantity},
                  secondary_sale.allocation_percentage: #{secondary_sale.allocation_percentage}"
  end

  def clean_up(secondary_sale)
    # Clean everythinteger
    secondary_sale.interests.update_all("allocation_percentage = 0.00,
      allocation_quantity = 0,
      final_price = #{secondary_sale.final_price},
      allocation_amount_cents = 0")
    secondary_sale.offers.update_all("allocation_percentage = 0,
      allocation_quantity = 0,
      final_price = #{secondary_sale.final_price},
      allocation_amount_cents = 0")
  end

  def update_offers(secondary_sale)
    interests = secondary_sale.interests.eligible(secondary_sale)
    offers = secondary_sale.offers.approved
    if secondary_sale.allocation_percentage <= 1
      # We have more interests than offers
      interests.update_all("allocation_percentage = 100.00,
                            allocation_quantity = quantity,
                            final_price = #{secondary_sale.final_price},
                            allocation_amount_cents = (quantity * 100 * #{secondary_sale.final_price})")

      # We only can allocate  a portion of the offers
      percentage = (1.0 * secondary_sale.allocation_percentage).round(6)
      logger.debug "allocating #{percentage}% of offers"
      offers.update_all(" allocation_percentage = #{100.00 * percentage},
                          allocation_quantity = ceil(quantity * #{percentage}),
                          final_price = #{secondary_sale.final_price},
                          allocation_amount_cents = (ceil(quantity * #{percentage}) * 100 * #{secondary_sale.final_price})")
    else
      # We have more offers than interests
      offers.update_all(" allocation_percentage = 100.00,
                          allocation_quantity = quantity,
                          final_price = #{secondary_sale.final_price},
                          allocation_amount_cents = (quantity * 100 * #{secondary_sale.final_price})")

      # We only can allocate a portion of the interests
      percentage = (1.0 / secondary_sale.allocation_percentage).round(6)
      logger.debug "allocating #{percentage}% of interests"
      interests.update_all("allocation_percentage = #{100.00 * percentage},
                            allocation_quantity = ceil(quantity * #{percentage}),
                            final_price = #{secondary_sale.final_price},
                            allocation_amount_cents = (ceil(quantity * #{percentage}) * 100 * #{secondary_sale.final_price})")
    end
  end

  def update_sale(secondary_sale)
    # Now compute the actual allocations and update it in the sale
    offers = secondary_sale.offers.approved
    offer_allocation_quantity = offers.sum(:allocation_quantity)
    offer_total_quantity = offers.sum(:quantity)
    logger.debug "offer_allocation_quantity: #{offer_allocation_quantity}"

    interests = secondary_sale.interests.eligible(secondary_sale)
    interest_allocation_quantity = interests.sum(:allocation_quantity)
    interest_total_quantity = interests.sum(:quantity)
    logger.debug "interest_allocation_quantity: #{interest_allocation_quantity}"

    secondary_sale.update(allocation_percentage: secondary_sale.allocation_percentage,
                          total_offered_quantity: offer_total_quantity,
                          total_offered_amount_cents: offer_total_quantity * secondary_sale.final_price * 100,
                          total_interest_quantity: interest_total_quantity,
                          total_interest_amount_cents: interest_total_quantity * secondary_sale.final_price * 100,
                          offer_allocation_quantity:,
                          allocation_offer_amount_cents: offer_allocation_quantity * secondary_sale.final_price * 100,
                          interest_allocation_quantity:,
                          allocation_interest_amount_cents: interest_allocation_quantity * secondary_sale.final_price * 100)
  end
  
end
