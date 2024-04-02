class CreateVendorOfferChats < ActiveRecord::Migration[6.1]
  def change
    create_table :vendor_offer_chats do |t|
      t.integer :user_id, index: true
      t.integer :vendor_user_id, index: true
      t.integer :vendor_offer_id, null: :false, index: true
      t.string :message, null: false

      t.timestamps
    end
  end
end
