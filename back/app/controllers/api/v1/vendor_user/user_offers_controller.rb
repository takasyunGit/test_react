class Api::V1::VendorUser::UserOffersController < ApplicationController
  before_action :authenticate_api_v1_vendor_user!

  def index
    @object = UserOffer.order(updated_at: :desc)
    if @object
      render json: { data: @object }
    else
      render_404
    end
  end

  def show
    from_table = UserOffer.where(id: params[:id])
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
end
