FactoryGirl.define do
  sequence :table_name do |n|
    "Table #{n}"
  end
  
  factory :table do
    name { Factory.next(:table_name) }
    association :user
    data_type "sql"
    data "SELECT * FROM cities"
  end
end
