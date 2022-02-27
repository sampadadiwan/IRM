module Users
  class PasswordsController < Devise::PasswordsController
    skip_before_action :require_no_authentication,
                       :assert_reset_token_passed,
                       only: :edit
  end
end
