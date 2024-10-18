class InvestorKycAction < Trailblazer::Operation
  def save(ctx, investor_kyc:, **)
    validate = ctx[:investor_user]
    investor_kyc.save(validate:)
  end

  def handle_errors(ctx, investor_kyc:, **)
    unless investor_kyc.valid?
      ctx[:errors] = investor_kyc.errors.full_messages.join(", ")
      Rails.logger.error("Investor KYC errors: #{investor_kyc.errors.full_messages}")
    end
    investor_kyc.valid?
  end

  def handle_kyc_sebi_data_errors(ctx, investor_kyc:, **)
    if investor_kyc.investor_kyc_sebi_data.valid?
      investor_kyc.investor_kyc_sebi_data.save!
    else
      ctx[:errors] = investor_kyc.investor_kyc_sebi_data.errors.full_messages.join(", ")
      Rails.logger.error("Investor KYC SEBI Data errors: #{investor_kyc.investor_kyc_sebi_data.errors.full_messages}")
    end
    investor_kyc.investor_kyc_sebi_data.valid?
  end

  def fix_folder_paths(ctx, investor_kyc:, **)
    document_folder = investor_kyc.document_folder
    parent_folder = document_folder.parent
    parent_folder.name = "KYC-#{investor_kyc.id}"
    path_parts = investor_kyc.folder_path.split("/")
    parent_folder.full_path = path_parts[0...-1].join("/")
    document_folder.owner = investor_kyc
    document_folder.save!
    parent_folder.save!
  end

  def validate_bank(_ctx, investor_kyc:, **)
    investor_kyc.validate_bank unless investor_kyc.destroyed?
    true
  end

  def create_investor_kyc_sebi_data(_ctx, investor_kyc:, **)
    result = true
    result = investor_kyc.create_investor_kyc_sebi_data unless investor_kyc.destroyed?
    result
  end

  def validate_pan_card(_ctx, investor_kyc:, **)
    investor_kyc.validate_pan_card unless investor_kyc.destroyed?
    true
  end

  def enable_kyc(_ctx, investor_kyc:, **)
    investor_kyc.enable_kyc
    true
  end

  def send_kyc_form_on_create(_ctx, investor_kyc:, investor_user:, **)
    SendKycFormJob.perform_later(investor_kyc.id) if investor_kyc.send_kyc_form_to_user && !investor_user
    true
  end

  def send_kyc_form(_ctx, investor_kyc:, investor_user:, **)
    SendKycFormJob.perform_later(investor_kyc.id) if investor_kyc.saved_change_to_send_kyc_form_to_user? && investor_kyc.send_kyc_form_to_user && !investor_user
    true
  end

  def updated_notification(_ctx, investor_kyc:, investor_user:, **)
    # reload the kyc in case it was changed from individual to non individual or visa versa
    investor_kyc = InvestorKyc.find(investor_kyc.id)
    investor_kyc.updated_notification if investor_user
    true
  end
end
