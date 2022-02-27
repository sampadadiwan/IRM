class ImportUploadJob < ApplicationJob
  queue_as :default

  def perform(import_upload_id)
    import_upload = ImportUpload.find(import_upload_id)

    file = Tempfile.new(["import_#{import_upload.id}", ".xlsx"], binmode: true)
    begin
      file << import_upload.import_file.download
      file.close

      Rails.logger.debug { "Downloaded file to #{file.path}" }

      data = Roo::Spreadsheet.open(file.path) # open spreadsheet
      headers = data.row(1) # get header row
      data.each_with_index do |row, idx|
        next if idx.zero? # skip header row

        # create hash from headers and cells
        user_data = [headers, row].transpose.to_h

        case import_upload.import_type
        when "InvestorAccess"
          save_investor_access(user_data, import_upload)
        else
          Rails.logger.error "Bad import_type #{import_upload.import_type} for import_upload #{import_upload.id}"
        end
      end
    ensure
      file.delete
    end
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
