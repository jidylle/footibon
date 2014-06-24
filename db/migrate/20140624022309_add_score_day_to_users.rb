class AddScoreDayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :scoreday, :integer, default: 0
  end
end
