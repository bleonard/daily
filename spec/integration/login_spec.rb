require 'integration_helper'

describe "Login" do
  
  before do
    @user = Factory(:user)
  end
  
  context "not signed in" do
    it "should allow login" do
      visit '/'
      fill_in("Email", :with => @user.email)
      fill_in("Password", :with => "password")
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
    
    it "should redirect to login when hit home" do
      visit "/home"
      current_path.should == '/'
      page.should have_content('Sign in')
    end
  end

  context "signed in" do
    before do
      login_as @user
    end
    
    it "should redirect to home from login" do
      visit "/"
      current_path.should == '/home'
    end    
  end

  
end