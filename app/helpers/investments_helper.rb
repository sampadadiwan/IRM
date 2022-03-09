module InvestmentsHelper

  FORMAT = I18n.t :format, scope: 'number.currency.format'

  def money_to_currency(money)
    case money.currency.iso_code
    when "INR"
      money.format(format: FORMAT, south_asian_number_formatting: true)
    when "SGD"
      money.format(format: FORMAT)
    when "USD"
      money.format(format: FORMAT)
    else
      money.format(format: FORMAT, south_asian_number_formatting: true)
    end
  end
end
