class Api::V1::User::UserOffersController < ApplicationController
  # before_action :user_signed_in?

  def create
    @object = current_user.user_offers.new(user_offer_params)
    @object.save!
    render json: { data: @object }
  rescue => e
    logger.error e
    logger.error e.backtrace.join("\n")
    render json: { messages: @object.errors.full_messages }
  end

  private

  def user_offer_params
    params.require(:user_offer).permit(:prefecture, :address, :budget, :remark, :request_type)
  end
end
