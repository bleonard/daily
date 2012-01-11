FactoryGirl.define do
  sequence :user_email do |n|
    "test#{n}@example.com"
  end
  
  factory :user, :class => DailyUser do
    email { Factory.next(:user_email) }
    password "password"
  end
  
  factory :admin, :parent => :user do
    admin true
  end
end
