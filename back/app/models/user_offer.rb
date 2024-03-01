class UserOffer < ApplicationRecord
  belongs_to :user_id

  validates :user_id,  presence: true
  validates :prefecture, presence: true, numericality: { in: 1..47 }
  validates :address, presence: true
  validates :type presence: true, numericality: { in: 1..3 }
end
