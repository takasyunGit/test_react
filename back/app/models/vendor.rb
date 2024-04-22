class Vendor < ApplicationRecord
  has_many :vendors

  validates :name, presence: true
  validates :prefecture, presence: true
  validates :address, presence: true
end
