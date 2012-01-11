class SqlQuery < Metric
  def self.display_name
    "SQL Query"
  end
  
  def result
    Ruport::Query.new(data).result
  end
end