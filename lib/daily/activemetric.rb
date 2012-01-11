module ActiveMetric
  class Base < ActiveRecord::Base
    establish_connection DailyConfig.database_config
    self.abstract_class = true
  end
end