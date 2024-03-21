class Api::V1::VendorUser::VendorOffersController < ApplicationController
  before_action :authenticate_api_v1_vendor_user!

  def create
    @object = current_api_v1_vendor_user.vendor_offers.new(vendor_offer_params)
    @object.save!
    render json: { data: @object }
  end

  private

  def vendor_offer_params
    params.require(:vendor_offer).permit(:user_offer_id, :remark, :estimate)
  end
end
