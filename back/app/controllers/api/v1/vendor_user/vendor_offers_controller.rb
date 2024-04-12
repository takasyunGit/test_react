class Api::V1::VendorUser::VendorOffersController < ApplicationController
  NUMBER_OF_PER_PAGE = 10
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

  private

  def vendor_offer_params
    params.require(:vendor_offer).permit(:user_offer_id, :title, :remark, :estimate)
  end
end
