class AddTransformToTable < ActiveRecord::Migration
  def up
    add_column :tables, :transform, :string
    add_column :tables, :transform_data, :text
    
    add_column :reports, :transform, :string
    add_column :reports, :transform_data, :text
  end
  def down
    remove_column :tables, :transform
    remove_column :tables, :transform_data
    
    remove_column :reports, :transform
    remove_column :reports, :transform_data
  end
end