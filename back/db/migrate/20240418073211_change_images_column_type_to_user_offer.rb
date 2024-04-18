class ChangeImagesColumnTypeToUserOffer < ActiveRecord::Migration[6.1]
  def up
    change_column :user_offers, :images, :json
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
