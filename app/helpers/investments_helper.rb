module InvestmentsHelper
  def money_to_currency(rupees, symbol)
    case symbol.strip
    when "INR"
      Money.new(rupees, "INR").format(south_asian_number_formatting: true)
    when "SGD"
      Money.new(rupees, "SGD").format
    when "USD"
      Money.new(rupees, "USD").format
    else
      Money.new(rupees, "INR").format(south_asian_number_formatting: true)
    end
  end
end
