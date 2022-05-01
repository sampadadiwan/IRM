class ElasticImporterJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    UserIndex.import
    EntityIndex.import
    InvestmentIndex.import
    AccessRightIndex.import
    DealInvestorIndex.import
    DocumentIndex.import
    HoldingIndex.import
    InvestorAccessIndex.import
    NoteIndex.import
    SecondarySaleIndex.import
  end
end
