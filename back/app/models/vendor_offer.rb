class VendorOffer < ApplicationRecord
  belongs_to :vendor_user_id

  validates :vendor_user_id,  presence: true
end
