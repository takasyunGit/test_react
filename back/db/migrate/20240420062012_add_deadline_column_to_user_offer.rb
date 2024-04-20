class AddDeadlineColumnToUserOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :user_offers, :deadline, :date
  end
end
