class CreateVendorOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :vendor_offers do |t|
      t.integer :vendor_user_id, null: false, index: true
      t.integer :estimate
      t.text :remark

      t.timestamps
    end
  end
end
