FactoryGirl.define do
  sequence :name do |n|
    "Table #{n}"
  end
  
  factory :table do
    name
    association :user
    data_type "sql"
    data "SELECT * FROM cities"
  end
end
