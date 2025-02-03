class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.text :memo, null: true
      t.integer :sum, null: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
