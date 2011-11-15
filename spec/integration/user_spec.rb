require 'integration_helper'

describe "User" do
  it "should not allow user creation" do
    lambda { visit "/users/sign_up" }.should raise_error
  end
  
  describe "Permissions" do
    before do
      @user = Factory(:user)
      login_as @user
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
  end
  
end