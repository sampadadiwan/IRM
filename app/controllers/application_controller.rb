class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include PublicActivity::StoreController

  skip_before_action :verify_authenticity_token

  after_action :verify_authorized, except: %i[index search], unless: :devise_controller?
  after_action :verify_policy_scoped, only: [:index]

  before_action :authenticate_user!
  before_action :set_search_controller
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  # skip_before_action :verify_authenticity_token, if: lambda { ENV["skip_authenticity_token"].present? }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone role entity_id])
  end

  def set_search_controller
    @search_controller = params[:controller] == "home" ? "entities" : params[:controller]
  end

  rescue_from Pundit::NotAuthorizedError do |_exception|
    redirect_to dashboard_entities_path, alert: "Access Denied"
  end

  before_action :prepare_exception_notifier

  private

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end
end
