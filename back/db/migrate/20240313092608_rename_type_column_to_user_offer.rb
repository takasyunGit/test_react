class RenameTypeColumnToUserOffer < ActiveRecord::Migration[6.1]
  def change
    rename_column :user_offers, :type, :request_type
  end
end
