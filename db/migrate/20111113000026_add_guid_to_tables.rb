class AddGuidToTables < ActiveRecord::Migration
  def up
    add_column :tables, :guid, :string
  end
  
  def down
    remove_column :tables, :guid
  end
end