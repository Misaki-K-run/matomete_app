class AddAiUsageCountToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :ai_usage_count, :integer, default: 0
    add_column :users, :ai_usage_date, :date, default: -> { 'CURRENT_DATE' }
  end
end
