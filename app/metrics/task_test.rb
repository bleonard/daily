class TaskTest < Metric
  class Task < ActiveMetric::Base
    belongs_to :user
  end
  
  class User < ActiveMetric::Base
    
  end
  
  def result
    out = Ruport::Data::Table.new( :column_names => ["user", "name", "charge_price"])
    Task.where(:state => "closed").take(5).each do |task|
      out << ["#{task.user.first_name} #{task.user.last_name}", task.name, task.charge_price]
    end
    out
  end
end