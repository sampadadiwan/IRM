class CreatePool
  include Interactor

  def call
    Rails.logger.debug "Interactor: CreatePool called"

    if context.option_pool.present?
      option_pool = context.option_pool
      context.fail!(message: option_pool.errors.full_messages) unless option_pool.save
    else
      Rails.logger.debug "No OptionPool specified"
      context.fail!(message: "No OptionPool specified")
    end
  end
end
