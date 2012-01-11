class NamespaceModels < ActiveRecord::Migration
  def self.up
    rename_table :users, :daily_users
    rename_table :reports, :daily_reports
    rename_table :tables, :daily_tables
  end

  def self.down
    rename_table :daily_tables, :tables
    rename_table :daily_reports, :reports
    rename_table :daily_users, :users
  end
end