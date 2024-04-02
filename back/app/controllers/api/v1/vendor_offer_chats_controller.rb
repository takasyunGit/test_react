class VendorOfferChatsController < ApplicationController
  NUMBER_OF_PER_PAGE = 10

  before_action :common_authentication!

  def index
    @objects = VendorOfferChat.where(vendor_offer_id: params[:vendor_offer_id])
    @objects = @objects.paginate_order(params[:key_id], "desc", NUMBER_OF_PER_PAGE, "created_at")
    render json: { data: @objects }
  end

  def create
    VendorOfferChat.create!(vendor_offer_chat_params)
    return render :index
  end

  private

  def vendor_offer_chat_params
    params = params.require(:vendor_offer_chat).permit(:vendor_offer_id, message: params[:message].sanitize)

    if current_user.kind_of(User)
      params.merge(user_id: current_user)
    else
      params.merge(vendor_user_id: current_user)
    end
  end
end
