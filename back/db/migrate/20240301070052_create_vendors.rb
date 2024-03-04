class CreateVendors < ActiveRecord::Migration[6.1]
  def change
    create_table :vendors do |t|
      t.string :name, null: false, index: true
      t.integer :prefecture, null: false, index: true
      t.string :address, null: false
      t.integer :capital


      t.timestamps
    end
  end
end
