# frozen_string_literal: true

class VendorUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  belongs_to :vendor
  has_many :vendor_offers
  has_many :vendor_offer_chats

  mount_uploader :avatar, AvatarUploader

  validates :vendor_id,  presence: true
end
