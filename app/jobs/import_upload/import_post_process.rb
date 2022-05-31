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
    file = nil
    case import_upload.import_type
    when "InvestorAccess"

    when "Holding"
      # We need to adjust the percentage holdings
      investment = import_upload.entity.actual_scenario.investments.first
      InvestmentPercentageHoldingJob.perform_now(investment.id)
      file = File.open("/tmp/import_result_#{import_upload.id}.xlsx")
      import_upload.import_results.attach(io: file, filename: "import_result_#{import_upload.id}.xlsx")

    end
    import_upload.save
    file&.delete
  end
end
