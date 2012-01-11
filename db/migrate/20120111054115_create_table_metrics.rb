class CreateTableMetrics < ActiveRecord::Migration
  module Migration
    class Table < ActiveRecord::Base
      def self.migrate(up)
        find_in_batches do |batch|
          batch.each do |t|
            if up
              t.up
            else
              t.down
            end
            t.save!
          end
        end
      end

      def self.record_timestamps
        # don't update updated_at stamp
        false
      end

      def up
        self.metric = "SqlQuery" if self.metric == "sql"
      end

      def down
        self.metric = "sql" if self.metric == "SqlQuery"
      end
    end
  end
  def self.up
    rename_column :tables, :data_type, :metric
    rename_column :tables, :data, :metric_data
    Migration::Table.migrate(true)
  end

  def self.down
    Migration::Table.migrate(false)
    rename_column :tables, :metric_data, :data
    rename_column :tables, :metric, :data_type
  end
end