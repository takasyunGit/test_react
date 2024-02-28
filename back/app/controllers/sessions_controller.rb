class SessionsController < ApplicationController
  def index
    render json: set_csrf_token[:value], status: :ok
  end
end
