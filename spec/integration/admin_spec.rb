require 'integration_helper'

describe "Admin" do
  before do
    @user = Factory(:admin)
    login_as @user
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
end