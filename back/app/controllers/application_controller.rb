class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  skip_before_action :verify_authenticity_token
  helper_method :current_user, :user_signed_in?

  def set_csrf_token
    cookies['CSRF-TOKEN'] = {
      domain: 'localhost', # フロント側ドメイン
      value: form_authenticity_token
    }
  end
end
