FactoryGirl.define do
  sequence :table_name do |n|
    "Table #{n}"
  end
  
  factory :table, :class => DailyTable do
    name { Factory.next(:table_name) }
    association :user
    metric "SqlQuery"
    metric_data "SELECT * FROM cities"
  end
end
