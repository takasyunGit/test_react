class AddNullFalseToRequestTypeColumnInUserOffer < ActiveRecord::Migration[6.1]
  def up
    change_column :user_offers, :request_type, :integer, null: false
  end

  def down
    change_column :user_offers, :request_type, :integer
  end
end
