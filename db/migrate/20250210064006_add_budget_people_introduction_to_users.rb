class AddBudgetPeopleIntroductionToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :budget, :integer
    add_column :users, :people, :integer
    add_column :users, :introduction, :string
  end
end
