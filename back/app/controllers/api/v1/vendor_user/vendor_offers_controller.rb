class Api::V1::VendorUser::VendorOffersController < ApplicationController
  include Api::V1::Concerns::SetImageUrl

  NUMBER_OF_PER_PAGE = 10

  before_action :authenticate_api_v1_vendor_user!

  def index
    @objects = VendorOffer.select(
        <<~SQL.gsub(/\n/," ")
          vendor_offers.*,
          vendor_users.name as vendor_user_name,
          vendor_users.avatar as avatar
        SQL
      ).joins(vendor_user: :vendor)
      .where(user_offer_id: params[:user_offer_id])
      .where(vendor_users: { vendor_id: current_api_v1_vendor_user.vendor_id})
    @objects = @objects.paginate_order(params[:key_id], "desc", NUMBER_OF_PER_PAGE, "updated_at")
    set_avatar_img_url(@objects[:records])

    render json: { data: @objects }
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

  def update
    @object = VendorOffer.where(id: params[:id], vendor_user_id: current_api_v1_vendor_user.id).first
    ActiveRecord::Base.transaction do
      @object.update!(vendor_offer_params)
      message = "ご提案の修正\n"
      message_hash = @object.previous_changes
      message_hash.delete("updated_at")
      message_hash.map do |key, value|
        case key
        when "estimate"
          message += "#{VendorOffer.human_attribute_name(key)}: ¥#{value.first.to_s(:delimited)} => ¥#{value.second.to_s(:delimited)}\n"
        when "remark"
          message += "#{VendorOffer.human_attribute_name(key)}: #{value.first}\n=>\n#{value.second}\n"
        else
          message += "#{VendorOffer.human_attribute_name(key)}: #{value.first} => #{value.second}"
        end
      end

      VendorOfferChat.create!(vendor_user_id: current_api_v1_vendor_user.id, vendor_offer_id: params[:id], message: message)
    end
    render json: { data: @object }
  end

  def destroy
    @object = VendorOffer.where(id: params[:id], vendor_user_id: current_api_v1_vendor_user.id).first
    ActiveRecord::Base.transaction do
      @object.destroy!
    end
    render json: { message: "Deletion succeeded"}
  end

  private

  def vendor_offer_params
    params.require(:vendor_offer).permit(:user_offer_id, :title, :remark, :estimate)
  end
end
