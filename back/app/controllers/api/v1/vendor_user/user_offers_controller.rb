class Api::V1::VendorUser::VendorOffersController < ApplicationController
  before_action :authenticate_vendor_user!

  def index
    @object = UserOffer.order(created_at: :desc)
    if @object
      render json: { data: @object }
    else
      render_404
    end
  end
end
