class DropItemsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :items, if_exists: true
  end
end
