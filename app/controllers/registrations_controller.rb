class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :require_no_authentication, only: [:new, :cancel]

    # POST /resource
  def create
    
    build_resource(sign_up_params)

    # A user is allowed to be created in 3 ways
    # 1. SignUp - no company_id is present
    # 2. Logged in user creates a user for his own company
    # 3. Logged in user creates a user for investors company

    if resource.company_id.present? 
      # Its ok
      # company_id has been sent
      if current_user
        if resource.company_id == current_user.company_id 
          # Its ok
          logger.debug "User being created for same company as current_user"      
        else
          if resource.company.company_type == "VC" 
            # TODO
            # Prevent user creation if its for a non investor company
            
            # This is ok
            logger.debug "User created for VC company. Setting role to Employee"
            resource.role = "Employee"            
          else
            resource.errors.add(:company_id, "User being created for a #{resource.company.company_type} company")     
          end
        end        
      else
        # We have a company_id but no logged in user
        # This is an error
        resource.errors.add(:company_id, "User being created for a company, without logged in current_user") 
      end
    else
      # Its Ok
      logger.debug "User created without company_id"      
    end

    resource.save
    logger.debug resource.errors.full_messages


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
      dashboard_companies_path
    else 
      after_sign_in_path_for(resource) if is_navigational_format?
    end
  end


end