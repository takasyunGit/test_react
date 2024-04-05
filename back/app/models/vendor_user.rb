# frozen_string_literal: true

class VendorUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :vendor_offers
  belongs_to :vendor

  mount_uploader :avatar, AvatarUploader

  validates :vendor_id,  presence: true
end
