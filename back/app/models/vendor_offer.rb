class VendorOffer < ApplicationRecord
  belongs_to :vendor_user

  validates :vendor_user_id,  presence: true
end
