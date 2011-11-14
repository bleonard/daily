class AddReportToDelayedJobs < ActiveRecord::Migration
  def up
    add_column :delayed_jobs, :report_id, :integer
    add_index :delayed_jobs, :report_id
  end
  
  def down
    remove_index :delayed_jobs, :report_id
    remove_column :delayed_jobs, :report_id
  end
end