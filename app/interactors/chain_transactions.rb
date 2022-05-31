class ChainTransactions
    include Interactor
  
    def call
      Rails.logger.debug "Interactor: ApprovePool called"
  
      if context.transactions.present?
        # Here we get a bunch of models which need to be saved in a transaction
        ActiveRecord::Base.transaction do
            context.transactions.each do |transaction|
                transaction.save
            end
        end
      else
        Rails.logger.debug "No transactions specified"
        context.fail!(message: "No transactions specified")
      end
    end
  
end
  