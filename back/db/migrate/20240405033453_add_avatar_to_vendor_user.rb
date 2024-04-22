class AddAvatarToVendorUser < ActiveRecord::Migration[6.1]
  def change
    add_column :vendor_users, :avatar, :string
  end
end
