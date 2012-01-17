class AddArchivedToTables < ActiveRecord::Migration
  def self.up
    add_column :daily_tables, :archived, :boolean, :default => false
    add_column :daily_reports, :archived, :boolean, :defualt => false
  end
  
  def self.down
    remove_column :daily_reports, :archived
    remove_column :daily_tables, :archived
  end
end