class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  skip_before_action :verify_authenticity_token
  helper_method :current_user, :user_signed_in?

  rescue_from StandardError, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def handle_error(e = nil)
    if e
      logger.error e
      logger.error e.backtrace.join("\n")
    end
  end

  def render_record_invalid(e = nil)
    handle_error(e)
    render json: { errors: { fullMessages: e.record.errors.full_messages } }, status: 422
  end

  def render_404(e = nil)
    handle_error(e)
    render json: { messages: "Page not found" }, status: 404
  end

  def render_500(e = nil)
    handle_error(e)
    render json: { messages: "An unexpected error has occurred" }, status: 500
  end

  def common_authentication!
    if params[:sign_in_type] == "User"
      current_user = current_api_v1_user
    else
      current_user = current_api_v1_vendor_user
    end
  end
end
