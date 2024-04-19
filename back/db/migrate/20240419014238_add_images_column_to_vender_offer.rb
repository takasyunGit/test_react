class AddImagesColumnToVenderOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :vendor_offers, :images, :json
  end
end
