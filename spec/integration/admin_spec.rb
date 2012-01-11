require 'integration_helper'

describe "Admin" do
  before do
    @daily_user = Factory(:admin)
    login_as @daily_user
  end
  
  describe "Permissions" do
    it "should be able to see all tables" do
      Factory(:table, :name => "Table1")
      Factory(:table, :name => "Table2")
      visit "/tables"
      page.should have_content("Table1")
      page.should have_content("Table2")
    end
    it "should be able to see all reports" do
      Factory(:report, :name => "Report1")
      Factory(:report, :name => "Report2")
      visit "/reports"
      page.should have_content("Report1")
      page.should have_content("Report2")
    end
  end
  
  describe "Managing users" do
    it "should allow editing email and password" do
      u = Factory(:user, :email => "bill@example.com")
      visit "/users/#{u.id}/edit"
      fill_in("Email", :with => "john@example.com")
      click_button("Update User")
      page.should have_content("User was successfully updated.")
      current_path.should == "/users/#{u.id}"
      page.should have_content("john@example.com")
    end
    
    it "should be able to create new users" do
      visit "/users/new"
      fill_in("Email", :with => "john@example.com")
      fill_in("Password", :with => "password")
      click_button("Create User")
      page.should have_content("User was successfully created.")
      current_path.should == "/users/#{DailyUser.last.id}"
      page.should have_content("john@example.com")
    end
  end
end