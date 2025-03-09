class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :ai_generate, foreign_key: true

      t.timestamps
    end
    add_index :favorites, [ :user_id, :ai_generate_id ], unique: true
  end
end
