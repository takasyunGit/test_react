class AddUserOfferIdToVendorOffers < ActiveRecord::Migration[6.1]
  def change
    add_column :vendor_offers, :user_offer_id, :integer, null: :false, index: true
  end
end
