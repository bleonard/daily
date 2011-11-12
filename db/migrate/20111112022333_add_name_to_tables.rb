class AddNameToTables < ActiveRecord::Migration
  def up
    add_column :tables, :name, :string
  end
  
  def down
    remove_column :tables, :name
  end
end