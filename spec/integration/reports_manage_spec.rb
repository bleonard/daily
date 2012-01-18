require 'integration_helper'

describe "Managing Reports" do
  before do
    @daily_user = Factory(:user)
    @table = Factory(:table, :user => @daily_user)
    login_as @daily_user
  end
  
  describe "Unarchiving" do
    it "should bring it back" do
      report = Factory(:report, :table => @table, :user => @daily_user, :archived => true)
      
      visit daily_table_daily_report_path(@table, report)
      page.should have_content("State: Archived")
    
      click_button("Unarchive")
      
      current_path.should == "/tables/#{@table.id}/reports/#{report.id}"
      page.should have_content("Report has been unarchived.")
      page.should have_content("State: Active")
    end
  end
  
  describe "Archiving" do
    it "should allow archiving" do
      report = Factory(:report, :table => @table, :user => @daily_user)
      
      visit daily_table_daily_report_path(@table, report)
      page.should have_content("State: Active")
    
      click_button("Archive")
      
      current_path.should == "/tables/#{@table.id}/reports/#{report.id}"
      page.should have_content("Report has been archived.")
      page.should have_content("State: Archived")
    end
    
    it "should allow deleting" do
      report = Factory(:report, :table => @table, :user => @daily_user)
      
      visit daily_table_daily_report_path(@table, report)
      page.should have_content("State: Active")
    
      click_button("Delete")
      
      current_path.should == "/tables/#{@table.id}"
      page.should have_content("Report has been deleted.")
    end
  end
end