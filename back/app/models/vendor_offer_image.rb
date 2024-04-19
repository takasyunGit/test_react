class VendorOfferImage < ApplicationRecord
  mount_uploader :content, VendorOfferImageUploader

  validates :vendor_offer_id, presence: true
  validates :content, presence: true

  belongs_to :vendor_offer
end
