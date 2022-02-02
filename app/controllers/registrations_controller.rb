class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :require_no_authentication, only: [:new, :cancel]

    # POST /resource
  def create
    
    build_resource(sign_up_params)
    # Ensure role is always Employee
    resource.add_role :employee
    
    # Ensure that users are created only for the same enetity as the logged in user.
    if current_user && !current_user.has_role?(:super)?
      resource.entity_id = current_user.entity_id 
      logger.debug "Setting new user entity to logged in users entity #{current_user.entity_id}"
    else
      # Check if this user was invited as an investor
      ar = AccessRight.user_access(resource).first
      if ar
        # Ensure this user is a user of the investor entity 
        ar.update_user
      end
    end

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


  protected

  def after_sign_up_path_for(resource)
    if current_user
      dashboard_entities_path
    else 
      after_sign_in_path_for(resource) if is_navigational_format?
    end
  end

  
  def after_inactive_sign_up_path_for(resource)
    welcome_users_path
  end

end