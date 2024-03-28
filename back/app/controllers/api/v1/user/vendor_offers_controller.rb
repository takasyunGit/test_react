class Api::V1::User::VendorOffersController < ApplicationController
  NUMBER_OF_PER_PAGE = 10
  before_action :authenticate_api_v1_user!

  def index
    @object = VendorOffer
      .select("vendor_offers.*, users.name")
      .joins(user_offer: :user)
      .where(user_offer_id: params[:user_offer_id])
      .where("user_offers.user_id": current_user.id)
    @object = @object.paginate_order(params[:key_id], "desc", NUMBER_OF_PER_PAGE, "updated_at")
    render json: { data: @object }
  end

  def show
    from_table = VendorOffer.where(id: params[:id])
    @object = VendorOffer
      .select("vendor_offers.*, users.name")
      .from(from_table, :vendor_offers)
      .joins(user_offer: :user)
      .where("user_offers.user_id": current_user.id)
    if @object
      render json: { data: @object.first }
    else
      render_404
    end
  end
end
