class ImportPortfolioInvestment < ImportUtil
  STANDARD_HEADERS = ["Fund", "Portfolio Company Name",	"Investment Date",	"Amount",
                      "Quantity",	"Instrument", "Investment Domicile", "Notes", "Type", "Folio No", "Sector", "Type Of Investee Company", "Type Of Security", "Isin", "Sebi Registration Number", "Is Associate", "Is Managed Or Sponsored By Aif"].freeze

  def standard_headers
    STANDARD_HEADERS
  end

  def post_process(ctx, import_upload:, **)
    super(ctx, import_upload:, **)
    # This ensures all the counters for this funds API are fixed
    # PortfolioInvestment.counter_culture_fix_counts only: :aggregate_portfolio_investment, where: { fund_id: import_upload.owner_id }
    # This will cause the compute_avg_cost to be called
    AggregatePortfolioInvestment.where(fund_id: import_upload.owner_id).find_each(&:save)
    true
  end

  def save_row(user_data, import_upload, custom_field_headers)
    portfolio_company_name, investment_date, amount_cents, quantity, instrument, investment_domicile, fund, commitment_type, capital_commitment = inputs(user_data, import_upload)

    portfolio_company = import_upload.entity.investors.portfolio_companies.where(investor_name: portfolio_company_name).first

    raise "Portfolio Company not found" if portfolio_company.nil?

    investment_instrument = portfolio_company.investment_instruments.find_or_initialize_by(name: instrument, investment_domicile:, entity_id: import_upload.entity_id)

    # add the sebi reporting fields in invesment instrument in json_fields (merge with any existing)
    investment_instrument.json_fields = (investment_instrument.json_fields || {}).merge(user_data.slice(*InvestmentInstrument::SEBI_REPORTING_FIELDS.stringify_keys.keys.map(&:titleize))&.transform_keys { |key| key.downcase.tr(' ', '_') })

    investment_instrument.save! # if investment_instrument.new_record?

    portfolio_investment = PortfolioInvestment.find_or_initialize_by(
      portfolio_company_name:, investment_date:, amount_cents:, quantity:, investment_instrument:, capital_commitment:, commitment_type:, fund:, entity_id: fund.entity_id
    )

    if portfolio_investment.new_record?

      Rails.logger.debug user_data

      # Save the PortfolioInvestment
      setup_custom_fields(user_data, portfolio_investment, custom_field_headers)
      portfolio_investment.notes = user_data["Notes"]
      portfolio_investment.created_by_import = true
      portfolio_investment.import_upload_id = import_upload.id
      portfolio_investment.portfolio_company = portfolio_company
      Rails.logger.debug { "Saving PortfolioInvestment with name '#{portfolio_investment.portfolio_company_name}'" }

      result = PortfolioInvestmentCreate.call(portfolio_investment:)
      raise result[:errors] unless result.success?

      result.success?
    else
      raise "PortfolioInvestment already exists"
    end
  end

  def inputs(user_data, import_upload)
    portfolio_company_name = user_data['Portfolio Company Name']
    investment_date = user_data["Investment Date"]
    amount_cents = user_data["Amount"].to_d * 100
    quantity = user_data["Quantity"].to_d
    instrument = user_data["Instrument"]
    investment_domicile = user_data["Investment Domicile"]
    fund = import_upload.entity.funds.where(name: user_data["Fund"]).last
    commitment_type = user_data["Type"]
    folio_id = user_data["Folio No"].presence
    capital_commitment = commitment_type == "CoInvest" ? fund.capital_commitments.where(folio_id:).first : nil

    [portfolio_company_name, investment_date, amount_cents, quantity, instrument, investment_domicile, fund, commitment_type, capital_commitment]
  end

  def defer_counter_culture_updates
    true
  end
end
