class CreateShoppingLists < ActiveRecord::Migration[7.2]
  def change
    create_table :shopping_lists do |t|
      t.references :post, null: false, foreign_key: true
      t.text :meat_fish, null: true
      t.text :vegetable, null: true
      t.text :other, null: true

      t.timestamps
    end
  end
end
