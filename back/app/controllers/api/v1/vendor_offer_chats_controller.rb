class Api::V1::VendorOfferChatsController < ApplicationController
  NUMBER_OF_PER_PAGE = 10

  before_action :common_authentication!

  def index
    @objects = VendorOfferChat.where(vendor_offer_id: params[:vendor_offer_id])
    @objects = @objects.paginate_order(params[:key_id], "desc", NUMBER_OF_PER_PAGE, "created_at")
    render json: { data: @objects }
  end

  def create
    VendorOfferChat.create!(vendor_offer_chat_params)
    return index
  end

  private

  def vendor_offer_chat_params
    if current_user.kind_of?(User)
      params.require(:vendor_offer_chat)
        .permit(:vendor_offer_id, :message)
        .merge(user_id: current_user.id)
    else
      params.require(:vendor_offer_chat)
        .permit(:vendor_offer_id, :message)
        .merge(vendor_user_id: current_user.id)
    end
  end
end
