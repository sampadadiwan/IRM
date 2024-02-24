class ImportPortfolioCashflow < ImportUtil
  include Interactor

  STANDARD_HEADERS = ["Fund", "Portfolio Company",	"Payment Date",	"Amount", "Tag", "Instrument",
                      "Instrument", "Notes", "Type", "Folio No"].freeze

  def standard_headers
    STANDARD_HEADERS
  end

  def save_portfolio_cashflow(user_data, import_upload, custom_field_headers)
    fund_id, portfolio_company, payment_date, amount_cents, instrument_name, commitment_type, _, tag, instrument = inputs(user_data, import_upload)

    investment_instrument = portfolio_company.investment_instruments.where(name: instrument_name).first
    entity_id = import_upload.entity_id

    aggregate_pi = import_upload.entity.aggregate_portfolio_investments.where(fund_id:, portfolio_company_id:, investment_instrument:, commitment_type:).first

    raise "Aggregate Portfolio Investment not found" if aggregate_pi.nil?

    portfolio_cashflow = PortfolioCashflow.find_or_initialize_by(entity_id:, fund_id:,
                                                                 portfolio_company_id:, tag:, instrument:,
                                                                 aggregate_portfolio_investment_id: aggregate_pi.id, payment_date:, amount_cents:)

    if portfolio_cashflow.new_record?

      Rails.logger.debug user_data

      # Save the PortfolioCashflow
      setup_custom_fields(user_data, portfolio_cashflow, custom_field_headers)
      portfolio_cashflow.notes = user_data["Notes"]
      portfolio_cashflow.import_upload_id = import_upload.id
      Rails.logger.debug { "Saving PortfolioCashflow with name '#{portfolio_cashflow.portfolio_company.investor_name}'" }
      portfolio_cashflow.save!
    else
      raise "PortfolioCashflow already exists"
    end
  end

  def inputs(user_data, import_upload)
    portfolio_company_name = user_data['Portfolio Company']
    portfolio_company = import_upload.entity.investors.where(investor_name: portfolio_company_name).first
    raise "Portfolio Company not found" if portfolio_company.nil?

    payment_date = user_data["Payment Date"]
    amount_cents = user_data["Amount"].to_d * 100
    tag = user_data["Tag"].presence || "Actual"
    instrument = user_data["Instrument"].presence || nil

    fund = import_upload.entity.funds.where(name: user_data["Fund"]).last
    raise "Fund not found" if fund.nil?

    fund_id = fund.id

    commitment_type = user_data["Type"]

    [fund_id, portfolio_company, payment_date, amount_cents, commitment_type, tag, instrument]
  end

  def process_row(headers, custom_field_headers, row, import_upload, _context)
    # create hash from headers and cells

    user_data = [headers, row].transpose.to_h
    Rails.logger.debug { "#### user_data = #{user_data}" }
    begin
      if save_portfolio_cashflow(user_data, import_upload, custom_field_headers)
        import_upload.processed_row_count += 1
        row << "Success"
      else
        import_upload.failed_row_count += 1
        row << "Error"
      end
    rescue ActiveRecord::Deadlocked => e
      raise e
    rescue StandardError => e
      Rails.logger.debug e.message
      row << "Error #{e.message}"
      Rails.logger.debug user_data
      Rails.logger.debug row
      import_upload.failed_row_count += 1
    end
  end
end
