class AddIndexToUpdatedAtOnVendorOffer < ActiveRecord::Migration[6.1]
  def change
    add_index :vendor_offers, :updated_at, name: :index_vendor_offers_on_updated_at
  end
end
