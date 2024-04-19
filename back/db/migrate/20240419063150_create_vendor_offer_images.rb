class CreateVendorOfferImages < ActiveRecord::Migration[6.1]
  def change
    create_table :vendor_offer_images do |t|
      t.integer :vendor_offer_id, null: :false, index: true
      t.json :content, null: :false

      t.timestamps
    end
  end
end
