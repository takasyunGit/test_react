class Api::V1::VendorUser::VendorOffersController < ApplicationController
  NUMBER_OF_PER_PAGE = 5
  before_action :authenticate_api_v1_vendor_user!

  def index
    @object = VendorOffer.where(user_offer_id: params[:user_offer_id], vendor_user_id: current_api_v1_vendor_user.id)
    @object = @object.paginate_order(params[:key_id], "desc", NUMBER_OF_PER_PAGE, "updated_at")
    render json: { data: @object }
  end

  def show
    from_table = VendorOffer.where(id: params[:id], vendor_user_id: current_api_v1_vendor_user.id)
    @object = VendorOffer
      .select("vendor_offers.*, users.name")
      .from(from_table, :vendor_offers)
      .joins(user_offer: :user)
    if @object
      render json: { data: @object.first }
    else
      render_404
    end
  end

  def create
    @object = current_api_v1_vendor_user.vendor_offers.new(vendor_offer_params)
    @object.save!
    render json: { data: @object }
  end

  private

  def vendor_offer_params
    params.require(:vendor_offer).permit(:user_offer_id, :title, :remark, :estimate)
  end
end
