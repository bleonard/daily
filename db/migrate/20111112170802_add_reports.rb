class AddReports < ActiveRecord::Migration
  def up
    create_table :reports, :force => true do |t|
      t.string :name
      t.string :filename
      t.integer :table_id
      t.integer :user_id
      t.string :formatter
      t.timestamps
    end
  end

  def down
  end
end