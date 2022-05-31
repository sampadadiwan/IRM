class ImportPostProcess
  include Interactor

  def call
    if context.import_upload.present?
      post_processing(context.import_upload)
    else
      context.fail!(message: "Required inputs not present")
    end
  end

  def post_processing(import_upload)
    result_file_name = "/tmp/import_result_#{import_upload.id}.xlsx"
    case import_upload.import_type
    when "InvestorAccess"

    when "Holding"
      # We need to adjust the percentage holdings
      investment = import_upload.entity.actual_scenario.investments.first
      InvestmentPercentageHoldingJob.perform_now(investment.id)
      result_file = File.open(result_file_name)
      import_upload.import_results.attach(io: result_file, filename: "import_result_#{import_upload.id}.xlsx")

    end
    import_upload.save
    File.delete(result_file_name) if File.exist? result_file_name
  end
end
