class Api::V1::VendorOfferChatsController < ApplicationController
  NUMBER_OF_PER_PAGE = 10
  require 'uri'

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
    # avatarのurlをfullpathで返却するために加工
    # ここのpathは本番環境で変わるので要修正
    domain = Rails.env.production? ? "http://localhost:3010" : "http://localhost:3010"
    @objects[:records] = @objects[:records].map do |obj|
      if obj.avatar
        if obj.user_id
          obj.avatar = { url: "#{domain}/uploads/user/avatar/#{obj.user_id}/#{URI.encode_www_form_component(obj.avatar)}" }
        end
        if obj.vendor_user_id
          obj.avatar = { url: "#{domain}/uploads/vendor_user/avatar/#{obj.vendor_user_id}/#{URI.encode_www_form_component(obj.avatar)}" }
        end
      end
      obj
    end
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
