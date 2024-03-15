class UserOffer < ApplicationRecord
  MAXIMUM_ADDRESS_LENGTH = 150

  belongs_to :user

  validates :user_id,  presence: true
  validates :prefecture, presence: true, numericality: { in: 1..47 }
  validates :address, length: { maximum: MAXIMUM_ADDRESS_LENGTH }
  validates :request_type, presence: true, numericality: { in: 1..3 }
end
