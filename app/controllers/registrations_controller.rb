class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :require_no_authentication, only: [:new, :cancel]

    # POST /resource
  def create
    
    build_resource(sign_up_params)
    # Ensure role is always Employee
    resource.role = "Employee"
    # Ensure that users are created only for the same enetity as the logged in user.
    resource.entity_id = current_user.entity_id if current_user && !current_user.is_super?

    resource.save
    

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end


  def after_sign_up_path_for(resource)
    if current_user
      dashboard_entities_path
    else 
      after_sign_in_path_for(resource) if is_navigational_format?
    end
  end


end