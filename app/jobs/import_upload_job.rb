class ImportUploadJob < ApplicationJob
  queue_as :default

  def perform(import_upload_id)
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
      import_upload.status ||= "Error"
      import_upload.error_text = e.backtrace
    ensure
      file.delete
    end

    import_upload.status ||= "Done. Processed #{processed_record_count} records"
    import_upload.save
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
    # Create the user if he does not exists
    user = User.find_by(email: user_data['Email'])
    unless user
      password = (0...8).map { rand(65..90).chr }.join
      user = User.create!(email: user_data["Email"], password: password,
                          first_name: user_data["First Name"],
                          last_name: user_data["Last Name"], active: true, system_created: true,
                          entity_id: import_upload.owner.investor_entity_id)

    end

    # create the Investor Access
    unless InvestorAccess.exists?(email: user_data['Email'], investor_id: import_upload.owner_id)
      InvestorAccess.create!(email: user_data["Email"], approved: true,
                             entity_id: import_upload.entity_id, investor_id: import_upload.owner_id,
                             granted_by: import_upload.user_id)
    end

    # Create the Holding
    holding = Holding.new(user: user, investor: import_upload.owner, holding_type: "Employee",
                          entity_id: import_upload.owner.investee_entity_id, quantity: user_data["Quantity"],
                          investment_instrument: user_data["Instrument"])

    holding.save
  end

  def save_investor_access(user_data, import_upload)
    # next if user exists
    if InvestorAccess.exists?(email: user_data['Email'], investor_id: import_upload.owner_id)
      Rails.logger.debug { "InvestorAccess with email #{user_data['Email']} already exists for investor #{import_upload.owner_id}" }
      return false
    end

    Rails.logger.debug user_data
    approved = user_data["Approved"] ? user_data["Approved"].strip == "Yes" : false
    ia = InvestorAccess.new(email: user_data["Email"], approved: approved,
                            entity_id: import_upload.entity_id, investor_id: import_upload.owner_id,
                            granted_by: import_upload.user_id)

    Rails.logger.debug { "Saving InvestorAccess with email '#{ia.email}'" }
    ia.save
  end
end
