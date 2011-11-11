require 'spec_helper'

describe "Login" do
  it "should show draft tasks in history" do
    user = Factory(:user, :password => "letmein")
  
    visit '/'
    fill_in("Email", :with => user.email)
    fill_in("Password", :with => "letmein")
    click_button("Sign in")
    
    current_path.should == '/home'
  end
end