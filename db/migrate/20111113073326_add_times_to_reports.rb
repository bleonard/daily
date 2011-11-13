class AddTimesToReports < ActiveRecord::Migration
  def up
    add_column :reports, :generate_started_at, :datetime
    add_column :reports, :generate_ended_at, :datetime
  end
  
  def down
    remove_column :reports, :generate_started_at
    remove_column :reports, :generate_ended_at
  end
end