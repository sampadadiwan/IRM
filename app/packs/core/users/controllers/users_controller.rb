class UsersController < ApplicationController
  before_action :authenticate_user!, except: %w[magic_link no_password_login welcome]
  # skip_before_action :verify_authenticity_token, only: %i[magic_link]

  skip_before_action :verify_authenticity_token, :authenticate_user!, only: %i[signature_progress whatsapp_webhook]
  skip_before_action :set_current_entity, only: %i[whatsapp_webhook]

  before_action :set_user, only: %w[show update destroy edit]
  after_action :verify_authorized, except: %i[welcome index search reset_password accept_terms set_persona magic_link no_password_login whatsapp_webhook]

  def welcome; end

  def chat
    authorize(User)

    chat_class = current_user.curr_role == "Investor" ? InvestorLlmChat : UserLlmChat
    @response = chat_class.new(user: current_user).query(params[:query])
  end

  def whatsapp_webhook
    user = User.find_by(phone: params[:waId][-10..], call_code: params[:waId][..-11])
    WhatsappChatJob.perform_later(user.id, params[:text]) if user && UserPolicy.new(user, user).whatsapp_webhook?
    render json: "Ok"
  end

  # GET /users or /users.json
  def index
    authorize(User)
    @users = policy_scope(User)
  end

  def search
    query = params[:query]
    if query.present?
      @users = UserIndex.filter(term: { entity_id: current_user.entity_id })
                        .query(query_string: { fields: %i[first_name last_name email],
                                               query:, default_operator: 'and' })

      render "index"
    else
      redirect_to users_path
    end
  end

  def magic_link
    @user = User.find_by(email: params[:user][:email]) if params[:user].present?
    @user ||= nil
    if @user.present?
      # redirect_to is the page from where the user was redirected to the login page
      @user.send_magic_link(params[:current_entity_id], params[:redirect_to])
      redirect_to new_session_path(User, display_status: true), notice: "Login link sent, please check your mailbox."
    else
      redirect_to new_session_path(User), notice: "User not found. Please signup."
    end
  end

  def no_password_login
    # If we have support trying to log in as this user, lets track that
    support_user_id = current_user&.has_cached_role?(:support) ? current_user.id : nil
    ActiveRecord::Base.connected_to(role: :writing) do
      if params[:signed_id]
        # Find user by signed id, the signed_id is generated as per https://kukicola.io/posts/signed-urls-with-ruby/
        @user = User.find_signed params[:signed_id]
        if @user.present?
          # Confirm user if not confirmed, as he has used his email to login
          @user.confirm unless @user.confirmed?
          # Sign in user
          sign_in @user
          # Set support user id if present, so audit trail can reflect who actually made changes. see ApplicationController.current_user_or_support_user and config/initializers/audited.rb
          session[:support_user_id] = support_user_id if support_user_id.present?
          # Redirect to root path
          redirect_to ( params[:redirect_to].presence ||
                        session[:user_return_to].presence ||
                        root_path), notice: "Signed in successfully"
        else
          redirect_to new_session_path(User), notice: "Invalid login link"
        end
      else
        redirect_to new_session_path(User), notice: "Invalid login link"
      end
    end
  end

  # GET /users/1 or /users/1.json
  def show
    authorize @user
  end

  # GET /users/new
  def new
    @user = params[:user].present? ? User.new(user_params) : User.new
    @user.entity_id = current_user.entity_id
    @user.permissions ||= current_user.permissions
    @user.extended_permissions ||= current_user.extended_permissions
    authorize @user
    setup_custom_fields(@user)
  end

  # GET /users/1/edit
  def edit
    authorize @user
    setup_custom_fields(@user)
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    authorize @user

    @user.extended_permissions = 0 if params[:user][:extended_permissions].blank?
    @user.permissions = 0 if params[:user][:permissions].blank?

    respond_to do |format|
      if @user.update(user_params)

        if current_user.has_cached_role?(:company_admin)
          User::UPDATABLE_ROLES.each do |role|
            user_params[:role_name].present? && user_params[:role_name].include?(role) ? @user.add_role(role) : @user.remove_role(role)
          end
        end
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    authorize @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def accept_terms
    current_user.accept_terms = true
    current_user.accepted_terms_on = Time.zone.now
    current_user.save

    # puts current_user.to_json

    redirect_to root_path
  end

  def set_persona
    ActiveRecord::Base.connected_to(role: :writing) do
      current_user.set_persona(params[:persona]) if params[:persona].present?
    end
    redirect_to request.referer || root_path
  end

  # This is used to reset password only for system generated users on the first login
  def reset_password
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    current_user.reset_password_token = hashed
    current_user.reset_password_sent_at = Time.now.utc
    current_user.save

    sign_out current_user

    redirect_to edit_user_password_path(reset_password_token: raw)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :phone, :whatsapp_enabled, :signature, :call_code,
                                 :dept, :sale_notification, :enable_support, role_name: [], permissions: [], extended_permissions: [], properties: {})
  end
end
