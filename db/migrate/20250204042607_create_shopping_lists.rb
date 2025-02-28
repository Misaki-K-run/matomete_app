class CreateShoppingLists < ActiveRecord::Migration[7.2]
  def change
    create_table :shopping_lists do |t|
      t.references :post, null: false, foreign_key: true
      t.string :category, null: true
      t.string :name, null: true

      t.timestamps
    end
  end
end
