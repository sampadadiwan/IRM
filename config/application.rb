require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module InvestorRelationshipManagement
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.to_prepare do
      Devise::Mailer.layout "mailer" # simple.haml or simple.erb
    end

    config.time_zone = 'New Delhi'
    config.active_record.default_timezone = :local

    config.secret_key_base = ENV['SECRET_KEY_BASE']

    config.active_job.queue_adapter = :sidekiq

    Rails.application.routes.default_url_options[:host]= ENV['HOST']
    
    config.action_mailer.smtp_settings = {
      :address => "email-smtp.us-west-1.amazonaws.com",
      :domain => "InvestorRelationshipManagement.com",
      :port => 587,
      :user_name => ENV["SES_SMTP_USERNAME"],
      :password => ENV["SES_SMTP_PASSWORD"],
      :authentication => :login,
      :enable_starttls_auto => true
    }


    Rails.application.config.middleware.use ExceptionNotification::Rack,
        email: {
          deliver_with: :deliver, # Rails >= 4.2.1 do not need this option since it defaults to :deliver_now
          email_prefix: '[Error:] ',
          sender_address: %{"Support" <#{ENV['SUPPORT_EMAIL']}>},
          exception_recipients: %{"ERROR" <#{ENV['ERROR_EMAIL']}>}
        }

  end
end
