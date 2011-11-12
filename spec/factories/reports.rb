FactoryGirl.define do
  sequence :report_name do |n|
    "Report #{n}"
  end
  
  factory :report do
    name { Factory.next(:report_name) }
    association :user
    association :table
    formatter "csv"
  end
end
