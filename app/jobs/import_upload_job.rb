class ImportUploadJob < ApplicationJob
  queue_as :default

  def perform(import_upload_id)
    Chewy.strategy(:sidekiq) do
      import_upload = ImportUpload.find(import_upload_id)
      import_upload.status = nil
      import_upload.error_text = nil

      processed_record_count = 0
      file = Tempfile.new(["import_#{import_upload.id}", ".xlsx"], binmode: true)
      begin
        # Download the S3 file to tmp
        file << import_upload.import_file.download
        file.close

        Rails.logger.debug { "Downloaded file to #{file.path}" }
        processed_record_count = process_file(file, import_upload)
      rescue StandardError => e
        import_upload.status ||= e.message
        import_upload.error_text = e.backtrace
        Rails.logger.error "Could not download file for import upload job #{import_upload_id} : #{e.message}"
        Rails.logger.error e.backtrace
      ensure
        file.delete
      end

      import_upload.status ||= "Done. Processed #{processed_record_count} records"
      import_upload.save
    end
  end

  def process_file(file, import_upload)
    processed_record_count = 0

    # Parse the XL rows
    data = Roo::Spreadsheet.open(file.path) # open spreadsheet
    headers = data.row(1) # get header row
    data.each_with_index do |row, idx|
      next if idx.zero? # skip header row

      # create hash from headers and cells
      user_data = [headers, row].transpose.to_h

      case import_upload.import_type
      when "InvestorAccess"
        processed_record_count += save_investor_access(user_data, import_upload) ? 1 : 0
      when "Holding"
        processed_record_count += save_holding(user_data, import_upload) ? 1 : 0
      else
        Rails.logger.error e.backtrace
        err_msg = "Bad import_type #{import_upload.import_type} for import_upload #{import_upload.id}"
        Rails.logger.error err_msg
        raise err_msg
      end
    end
    # return how many we processed
    processed_record_count
  end

  def save_holding(user_data, import_upload)
    Rails.logger.debug { "Processing holdings #{user_data}" }

    # Find the Founder or Employee Investor for the entity
    investor = Investor.where(investee_entity_id: import_upload.owner_id,
                              is_holdings_entity: true, category: user_data["Founder or Employee"]).first

    # Create the user if he does not exists
    user = User.find_by(email: user_data['Email'])
    unless user
      password = (0...8).map { rand(65..90).chr }.join
      user = User.create!(email: user_data["Email"], password:,
                          first_name: user_data["First Name"],
                          last_name: user_data["Last Name"], active: true, system_created: true,
                          entity_id: investor.investor_entity_id)

    end

    # create the Investor Access
    if InvestorAccess.where(email: user_data['Email'], investor_id: investor.id).first.blank?
      InvestorAccess.create(email: user_data["Email"], approved: true,
                            entity_id: import_upload.owner_id, investor_id: investor.id,
                            granted_by: import_upload.user_id)

    end

    fr, ep, grant_date = get_fr_ep(user_data, import_upload)
    price_cents = ep ? ep.excercise_price_cents : user_data["Price"].to_f * 100

    holding = Holding.new(user:, investor:, holding_type: user_data["Founder or Employee"],
                          entity_id: import_upload.owner_id, quantity: user_data["Quantity"],
                          price_cents:, employee_id: user_data["Employee ID"],
                          investment_instrument: user_data["Instrument"],
                          funding_round: fr, esop_pool: ep,
                          import_upload_id: import_upload.id, grant_date:)

    holding.save!
  end

  def get_fr_ep(user_data, import_upload)
    if user_data["Instrument"] == "Options"
      ep = esop_pool(user_data, import_upload)
      fr = ep.funding_round
      date_val = user_data["Grant Date (mm/dd/yyyy)"]
      begin
        grant_date = Date.strptime(date_val.to_s, "%m/%d/%Y")
      rescue StandardError
        grant_date = DateTime.parse(date_val.to_s)
      end
    else
      fr = funding_round(user_data, import_upload)
      ep = nil
      grant_date = nil
    end

    [fr, ep, grant_date]
  end

  def funding_round(user_data, import_upload)
    # Create the Holding
    col = "Funding Round or ESOP Pool"
    fr = FundingRound.where(entity_id: import_upload.owner_id, name: user_data[col].strip).first
    fr ||= FundingRound.create(name: user_data[col].strip,
                               entity_id: import_upload.owner_id,
                               currency: import_upload.owner.currency,
                               status: "Open")

    fr
  end

  def esop_pool(user_data, import_upload)
    # Create the Holding
    col = "Funding Round or ESOP Pool"
    EsopPool.where(entity_id: import_upload.owner_id, name: user_data[col].strip).first
  end

  def save_investor_access(user_data, import_upload)
    # next if user exists
    if InvestorAccess.exists?(email: user_data['Email'], investor_id: import_upload.owner_id)
      Rails.logger.debug { "InvestorAccess with email #{user_data['Email']} already exists for investor #{import_upload.owner_id}" }
      return false
    end

    Rails.logger.debug user_data
    approved = user_data["Approved"] ? user_data["Approved"].strip == "Yes" : false
    ia = InvestorAccess.new(email: user_data["Email"], approved:,
                            entity_id: import_upload.entity_id, investor_id: import_upload.owner_id,
                            granted_by: import_upload.user_id)

    Rails.logger.debug { "Saving InvestorAccess with email '#{ia.email}'" }
    ia.save
  end
end
