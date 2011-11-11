class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :tables, :force => true do |t|
      t.integer :user_id
      t.text :data
      t.string :data_type
      t.timestamps
    end
  end

  def self.down
    drop_table :tables
  end
end