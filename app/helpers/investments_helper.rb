module InvestmentsHelper
  FORMAT = I18n.t :format, scope: 'number.currency.format'

  def money_to_currency(money, params = {})
    sanf = true
    money = money.clone

    units = ""
    if params[:units].present?
      units = case params[:units]
              when "Crores"
                money /= 10_000_000
                sanf = true
                params[:units]
              when "Lakhs"
                money /= 100_000
                sanf = true
                params[:units]
              when "Million"
                money /= 1_000_000
                sanf = false
                params[:units]
              end
    end

    display(money, sanf, units)
  end

  def display(money, sanf, units)
    display_val = case money.currency.iso_code
                  when "INR"
                    money.format(format: FORMAT, south_asian_number_formatting: sanf)
                  when "SGD"
                    money.format(format: FORMAT)
                  when "USD"
                    money.format(format: FORMAT)
                  else
                    money.format(format: FORMAT, south_asian_number_formatting: sanf)
                  end

    "#{display_val} #{units}"
  end
end
