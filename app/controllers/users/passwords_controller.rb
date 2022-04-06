module Users
  class PasswordsController < Devise::PasswordsController
    skip_before_action :require_no_authentication,
                       :assert_reset_token_passed,
                       only: %i[edit update]

    private

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
    end
  end
end
