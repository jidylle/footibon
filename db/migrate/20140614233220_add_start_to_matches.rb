class AddStartToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :is_start, :boolean
  end
end
