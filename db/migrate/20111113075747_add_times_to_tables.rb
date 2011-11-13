class AddTimesToTables < ActiveRecord::Migration
  def up
    add_column :tables, :fetch_time_in_seconds, :integer
  end
  
  def down
    remove_column :tables, :fetch_time_in_seconds
  end
end