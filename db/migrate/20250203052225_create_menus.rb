class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus do |t|
      t.references :post, foreign_key: true
      t.text :monday, null: true
      t.text :tuesday, null: true
      t.text :wednesday, null: true
      t.text :thursday, null: true
      t.text :friday, null: true
      t.text :saturday, null: true
      t.text :sunday, null: true

      t.timestamps
    end
  end
end
