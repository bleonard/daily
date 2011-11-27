class AddColumnNamesToTable < ActiveRecord::Migration
  def up
    add_column :tables, :column_names, :text
  end
  
  def down
    remove_column :tables, :column_names
  end
end
