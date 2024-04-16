require 'uri'
class Api::V1::VendorOfferChatsController < ApplicationController
  include Api::V1::Concerns::SetImageUrl

  NUMBER_OF_PER_PAGE = 10

  before_action :common_authentication!

  def index
    @objects = VendorOfferChat.select(
        <<~SQL.gsub(/\n/," ")
          vendor_offer_chats.*,
          COALESCE(users.name, vendor_users.name, '不明なユーザー') as name,
          COALESCE(users.avatar, vendor_users.avatar) as avatar
        SQL
      )
      .where(vendor_offer_id: params[:vendor_offer_id])
      .joins(
        <<~SQL
          LEFT OUTER JOIN users ON vendor_offer_chats.user_id = users.id
          LEFT OUTER JOIN vendor_users ON vendor_offer_chats.vendor_user_id = vendor_users.id
        SQL
      )
    @objects = @objects.paginate_order(params[:key_id], "desc", NUMBER_OF_PER_PAGE, "created_at")
    set_avatar_img_url(@objects[:records])

    render json: { data: @objects }
  end

  def create
    VendorOfferChat.create!(vendor_offer_chat_params)
    return index
  end

  private

  def vendor_offer_chat_params
    if @@current_user.kind_of?(User)
      params.require(:vendor_offer_chat)
        .permit(:vendor_offer_id, :message)
        .merge(user_id: @@current_user.id)
    else
      params.require(:vendor_offer_chat)
        .permit(:vendor_offer_id, :message)
        .merge(vendor_user_id: @@current_user.id)
    end
  end
end
