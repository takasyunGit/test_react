class Api::V1::User::UserOffersController < ApplicationController
  before_action :authenticate_user!

  def index
    @object = UserOffer.where(user_id: current_user.id).order(created_at: :desc)
    render json: { data: @object }
  end

  def show
    from_table = UserOffer.where(user_id: current_user.id, id: params[:id])
    @object = UserOffer
      .select("user_offers.*, users.name")
      .from(from_table, :user_offers)
      .joins(:user)
    if @object
      render json: { data: @object.first }
    else
      render_404
    end
  end

  def create
    @object = current_user.user_offers.new(user_offer_params)
    @object.save!
    render json: { data: @object }
  end

  private

  def user_offer_params
    params.require(:user_offer).permit(:prefecture, :address, :budget, :remark, :request_type, :deadline, {images: []})
  end
end
