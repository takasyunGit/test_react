class UserOffer < ApplicationRecord
  belongs_to :user

  validates :user_id,  presence: true
  validates :prefecture, presence: true, numericality: { in: 1..47 }
  validates :address, presence: true
  validates :type presence: true, numericality: { in: 1..3 }
end
