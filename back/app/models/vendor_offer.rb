class VendorOffer < ApplicationRecord
  MAXIMUM_TITLE_LENGTH = 100

  has_many :vendor_offer_chats, dependent: :destroy
  has_many :vendor_offer_images, dependent: :destroy

  belongs_to :vendor_user
  belongs_to :user_offer

  validates :vendor_user_id, presence: true
  validates :user_offer_id, presence: true
  validates :title, length: {maximum: MAXIMUM_TITLE_LENGTH}, presence: true
end
