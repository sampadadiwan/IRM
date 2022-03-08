module InvestmentsHelper
  def money_to_currency(amount, symbol)
    Rails.logger.debug { "xxxxxxxxxxxxxxxxxx #{symbol}" }
    case symbol.strip
    when "INR"
      Money.new(amount, "INR").format(south_asian_number_formatting: true)
    when "SGD"
      Money.new(amount, "SGD").format
    when "USD"
      Rails.logger.debug { "################ #{symbol}" }
      Money.new(amount, "USD").format
    else
      Money.new(amount, "INR").format(south_asian_number_formatting: true)
    end
  end
end
