class ImportFundFormula < ImportUtil
  # FundFormula does not have a custom_field model
  step nil, delete: :create_custom_fields

  STANDARD_HEADERS = ["Sequence", "Name", "Rule Type", "Rule For", "Commitment Type", "Formula", "Entry Type", "Rollup", "Enabled", "Tag List", "Generate Ytd, Quarterly, Since Inception Numbers"].freeze

  def standard_headers
    STANDARD_HEADERS
  end

  def save_row(row_data, import_upload, _custom_field_headers, _ctx)
    Rails.logger.debug row_data

    fund = import_upload.owner
    raise "Fund not found" unless fund

    name = row_data["Name"]
    entry_type = row_data["Entry Type"]
    formula = row_data["Formula"]
    commitment_type = row_data["Commitment Type"]
    rule_type = row_data["Rule Type"]
    rule_for = row_data["Rule For"]
    tag_list = row_data["Tag List"]
    generate_ytd_qtly = row_data["Generate Ytd, Quarterly, Since Inception Numbers"]&.downcase == "yes"

    fund_formula = fund.fund_formulas.find_or_initialize_by(entity_id: fund.entity_id, name:, formula:, entry_type:, rule_for:, rule_type:, commitment_type:, generate_ytd_qtly:)

    if fund_formula.id.present?
      raise "FundFormula #{fund_formula.id} already exists"
    else
      fund_formula.assign_attributes(fund_id: fund.id, sequence: row_data["Sequence"], roll_up: row_data["Rollup"], enabled: row_data["Enabled"], import_upload_id: import_upload.id, tag_list:)
      fund_formula.save!
    end

    true
  end
end
