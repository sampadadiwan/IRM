class ApprovePool
  include Interactor

  def call
    Rails.logger.debug "Interactor: ApprovePool called"

    if context.option_pool.present?
      option_pool = context.option_pool
      option_pool.approved = true
      context.fail!(message: option_pool.errors.full_messages) unless option_pool.save
    else
      Rails.logger.debug "No OptionPool specified"
      context.fail!(message: "No OptionPool specified")
    end
  end
end
