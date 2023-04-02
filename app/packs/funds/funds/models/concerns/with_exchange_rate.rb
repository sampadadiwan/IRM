module WithExchangeRate
  extend ActiveSupport::Concern

  included do
    belongs_to :exchange_rate, optional: true
  end

  def convert_currency(from, to, amount, as_of)
    if to == from
      amount
    else
      raise "No date specified" unless as_of

      @exchange_rate = get_exchange_rate(from, to, as_of)
      if @exchange_rate
        # This sets the exchange rate being used for the conversion
        self.exchange_rate = @exchange_rate
        # puts "Using exchange_rate #{exchange_rate} for #{self}"
        self.exchange_rate = @exchange_rate if respond_to? :exchange_rate
        amount * exchange_rate.rate
      else
        raise "Exchange rate from #{from} to #{to} not found for date #{as_of}."
      end
    end
  end

  def get_exchange_rate(from, to, as_of)
    exchange_rates = entity.exchange_rates.where(from:, to:).order(as_of: :asc)
    @exchange_rate = as_of ? exchange_rates.where("as_of <= ?", as_of).last : exchange_rates.latest.last
    @exchange_rate
  end
end
