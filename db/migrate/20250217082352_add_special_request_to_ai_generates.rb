class AddSpecialRequestToAiGenerates < ActiveRecord::Migration[7.2]
  def change
    add_column :ai_generates, :special_request, :string, null: true
  end
end
