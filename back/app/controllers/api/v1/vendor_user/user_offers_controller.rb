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
end
