class VendorOffer < ApplicationRecord
  belongs_to :vendor_user
  belongs_to :user_offer

  validates :vendor_user_id,  presence: true
  validates :user_offer_id,  presence: true
end
