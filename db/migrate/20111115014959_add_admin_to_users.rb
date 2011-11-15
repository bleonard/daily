class AddAdminToUsers < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean
  end
  
  def down
    remove_column :users, :admin
  end
end