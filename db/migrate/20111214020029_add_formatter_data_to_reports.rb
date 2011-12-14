class AddFormatterDataToReports < ActiveRecord::Migration
  def up
    add_column :reports, :formatter_data, :text
  end
  def down
    remove_column :reports, :formatter_data
  end
end
