require 'integration_helper'

describe "User" do
  it "should not allow user creation" do
    lambda { visit "/users/sign_up" }.should raise_error
  end
  
  describe "Permissions" do
    before do
      @daily_user = Factory(:user)
      login_as @daily_user
    end
    
    it "should not able able to see all Tables" do
      Factory(:table, :name => "Table1")
      visit "/tables"
      page.should have_content("The page you were looking for doesn't exist.")
      page.should have_no_content("Table1")
    end
    
    it "should not able able to see all Reports" do
      Factory(:report, :name => "Report1")
      visit "/reports"
      page.should have_content("The page you were looking for doesn't exist.")
      page.should have_no_content("Report1")
    end
    
    it "should not allow the editing of someone elses profile" do
      u = Factory(:user)
      visit "/users/#{u.id}/edit"
      page.should have_content("The page you were looking for doesn't exist.")
      page.should have_no_content u.email
      
      visit "/users/#{@daily_user.id}/edit"
      page.should have_no_content("The page you were looking for doesn't exist.")
      page.should have_content @daily_user.email
    end
    
    it "should not allow the creation of a user" do
      visit "/users/new"
      page.should have_content("The page you were looking for doesn't exist.")
    end
  end
  
  describe "Account Management" do
    before do
      @daily_user = Factory(:user, :email => "james@example.com")
      login_as @daily_user
    end
    
    it "should allow editing of email and password" do
      visit "/account"
      fill_in("Email", :with => "john@example.com")
      click_button("Update User")
      page.should have_content("User was successfully updated.")
      current_path.should == '/home'
      page.should have_content("Welcome john@example.com")
    end
  end
end