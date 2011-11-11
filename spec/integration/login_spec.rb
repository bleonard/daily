require 'spec_helper'

describe "Login" do
  before do
    @user = Factory(:user, :password => "letmein")
  end
  
  it "should allow login" do
    visit '/'
    fill_in("Email", :with => @user.email)
    fill_in("Password", :with => "letmein")
    click_button("Sign in")
    
    current_path.should == '/home'
    page.should have_content('Signed in successfully.')
  end
  
  it "should show validations" do
    visit '/'
    fill_in("Email", :with => @user.email)
    fill_in("Password", :with => "wrong!")
    click_button("Sign in")
    
    current_path.should == '/users/sign_in'
    page.should have_content('Invalid email or password.')
  end
  
end