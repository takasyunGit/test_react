class VendorOfferImage < ApplicationRecord
  mount_uploader :content, VendorOfferImageUploader

  belongs_to :vendor_offer
end
