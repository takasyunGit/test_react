class VendorOfferChat < ApplicationRecord
  MAXIMUM_MESSAGE_LENGTH = 2000

  belongs_to :vendor_offer
  belongs_to :vendor_user
  belongs_to :user

  validates :user_id, presence: true
  validates :vendor_user_id, presence: true
  validates :vendor_offer_id, presence: true
  validates :message, length: { maximum: MAXIMUM_MESSAGE_LENGTH }
end
