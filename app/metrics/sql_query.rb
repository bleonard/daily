class SqlQuery < Metric
  validates_presence_of_data
  
  def self.display_name
    "SQL Query"
  end
  
  def result
    Ruport::Query.new(data).result
  end
end