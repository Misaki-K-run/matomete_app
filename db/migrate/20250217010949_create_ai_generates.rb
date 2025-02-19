class CreateAiGenerates < ActiveRecord::Migration[7.2]
  def change
    create_table :ai_generates do |t|
      t.integer :budget_request, null: false
      t.integer :people_request, null: false
      t.text :allergies, null: true
      t.text :favorite_ingredients, null: true
      t.jsonb :menu_response, default: {}, null: false
      t.jsonb :shopping_list_response, default: {}, null: false
      t.integer :sum_response, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
