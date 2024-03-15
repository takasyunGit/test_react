class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  skip_before_action :verify_authenticity_token
  helper_method :current_user, :user_signed_in?

  rescue_from StandardError, with: :render_500

  def render_500(e = nil)
    if e
      logger.error e
      logger.error e.backtrace.join("\n")
    end
    render json: { status: 500, messages: "An unexpected error has occurred" }
  end
end
