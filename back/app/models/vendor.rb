class Vendor < ApplicationRecord
  validates :name, presence: true
  validates :prefecture, presence: true
  validates :address, presence: true
end
