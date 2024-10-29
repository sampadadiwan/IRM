class ImportAccountEntry < ImportUtil
  STANDARD_HEADERS = ["Investor", "Fund", "Folio No", "Reporting Date", "Entry Type", "Name", "Amount", "Notes", "Type", "Rule For"].freeze
  attr_accessor :account_entries

  def standard_headers
    STANDARD_HEADERS
  end

  def initialize(**)
    super
    @account_entries = []
  end

  def save_row(user_data, import_upload, custom_field_headers, _ctx)
    Rails.logger.debug { "Processing account_entry #{user_data}" }

    # Get the Fund
    folio_id, name, entry_type, reporting_date, period, investor_name, amount_cents, fund, capital_commitment, investor = get_fields(user_data, import_upload)

    if fund && ((investor_name && capital_commitment) || investor_name.blank?)
      # ret_val = prepare_record(user_data, import_upload, custom_field_headers)
      save_account_entry(user_data, import_upload, custom_field_headers)
    else
      raise "Fund not found" if fund.nil?
      raise "Commitment not found" if capital_commitment.nil?
    end
  end

  def save_account_entry(user_data, import_upload, custom_field_headers)
    folio_id, name, entry_type, reporting_date, period, investor_name, amount_cents, fund, capital_commitment, investor, rule_for = get_fields(user_data, import_upload)

    if fund

      # Note this could be an entry for a commitment or for a fund (i.e no commitment)
      account_entry = AccountEntry.find_or_initialize_by(entity_id: import_upload.entity_id, folio_id:, fund:, capital_commitment:, investor:, reporting_date:, entry_type:, rule_for:, name:, amount_cents:)

      if account_entry.new_record? && account_entry.valid?
        account_entry.notes = user_data["Notes"]
        account_entry.import_upload_id = import_upload.id
        account_entry.commitment_type = user_data["Type"]
        setup_custom_fields(user_data, account_entry, custom_field_headers)

        account_entry.save!
      else
        msg = "Duplicate, already present"
        Rails.logger.debug { "#{msg} #{account_entry}" }
        raise msg unless account_entry.new_record?
        raise account_entry.errors.full_messages.join(",") unless account_entry.valid?
      end
    else
      raise "Fund not found" unless fund
    end
  end

  def get_fields(user_data, import_upload)
    folio_id = user_data["Folio No"]&.to_s
    name = user_data["Name"].presence
    entry_type = user_data["Entry Type"].presence
    reporting_date = user_data["Reporting Date"].presence
    investor_name = user_data["Investor"]
    amount_cents = user_data["Amount"].to_d * 100
    period = user_data["Period"]
    rule_for = user_data["Rule For"]&.downcase

    fund = import_upload.entity.funds.where(name: user_data["Fund"]).first
    raise "Fund not found" unless fund

    capital_commitment = investor_name.present? ? fund.capital_commitments.where(investor_name:, folio_id:).first : nil
    investor = capital_commitment&.investor
    raise "Commitment not found" if folio_id.present? && capital_commitment.nil?

    [folio_id, name, entry_type, reporting_date, period, investor_name, amount_cents, fund, capital_commitment, investor, rule_for]
  end
end
