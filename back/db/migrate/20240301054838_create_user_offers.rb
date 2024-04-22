class CreateUserOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_offers do |t|
      t.integer :user_id, null: false, index: true
      t.integer :prefecture, null: false, index: true
      t.string :address, null: false
      t.integer :budget
      t.text :remark
      t.integer :type

      t.timestamps
    end
  end
end
