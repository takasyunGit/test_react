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
    from_table = VendorOffer.joins(vendor_user: :vendor).where(id: params[:id], vendor_users: { vendor_id: current_api_v1_vendor_user.vendor_id})
    @object = VendorOffer
      .select("vendor_offers.*, users.name")
      .from(from_table, :vendor_offers)
      .joins(user_offer: :user)
    @images =  @object.first.vendor_offer_images
    if @object
      render json: { data: { vendor_offer: @object.first, images: @images } }
    else
      render_404
    end
  end

  def create
    ActiveRecord::Base.transaction do
      @object = current_api_v1_vendor_user.vendor_offers.new(vendor_offer_params)
      @object.save!
      if vendor_offer_images_params[:images].present?
        @images = vendor_offer_images_params[:images].map do |image|
          @object.vendor_offer_images.create!(content: image)
        end
      end
    end

    render json: { data: @object }
  end

  def update
    ActiveRecord::Base.transaction do
      @object = VendorOffer
        .select("vendor_offers.*, users.name")
        .joins(user_offer: :user)
        .where(id: params[:id], vendor_user_id: current_api_v1_vendor_user.id)
        .first
      @object.update!(vendor_offer_params)
      vendor_offer_images_params[:remove_image_ids].delete_if{ |id| id.match(/^blob:http/) } if vendor_offer_images_params[:remove_image_ids].present?
      delete_images = @object.vendor_offer_images.where(id: vendor_offer_images_params[:remove_image_ids])
      if delete_images.present?
        delete_images.map do |delete_image|
          delete_image.destroy!
        end
      end
      if vendor_offer_images_params[:images]
        images = vendor_offer_images_params[:images].map do |image|
          @object.vendor_offer_images.create!(content: image)
        end
      end

      modify_image_alert = delete_images.present? || images.present?
      message_hash = @object.previous_changes
      if @object.previous_changes.present? || modify_image_alert
        message = "ご提案の修正\n"
        message_hash.delete("updated_at")
        message_hash.map do |key, value|
          case key
          when "estimate"
            message += "・#{VendorOffer.human_attribute_name(key)}: ¥#{value.first.to_s(:delimited)} => ¥#{value.second.to_s(:delimited)}\n"
          when "remark"
            message += "・#{VendorOffer.human_attribute_name(key)}: #{value.first}\n=>\n#{value.second}\n"
          else
            message += "・#{VendorOffer.human_attribute_name(key)}: #{value.first} => #{value.second}\n"
          end
        end
        message += "・画像を修正しました。\n" if modify_image_alert

        VendorOfferChat.create!(vendor_user_id: current_api_v1_vendor_user.id, vendor_offer_id: params[:id], message: message)
      end
    end
    render json: { data: { vendor_offer: @object, images: @object.vendor_offer_images} }
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

  def vendor_offer_images_params
    return {} unless params[:vendor_offer_image].present?
    params.require(:vendor_offer_image).permit({images: []}, remove_image_ids: [])
  end
end
