class AddTitleColumnToVendorOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :vendor_offers, :title, :string, null: :false
  end
end
