class ChangeMessageColumnToVendorOfferChat < ActiveRecord::Migration[6.1]
  def up
    change_column :vendor_offer_chats, :message, :text, null: false
  end

  def down
    change_column :vendor_offer_chats, :message, :string, null: false
  end
end
