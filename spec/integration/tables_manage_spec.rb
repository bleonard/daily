require 'integration_helper'

describe "Managing Tables" do
  before do
    @daily_user = Factory(:user)
    login_as @daily_user
  end

  it "should not allow editing of a table that is not mine" do
    other = Factory(:table)
    visit edit_daily_table_path(other)
    page.should have_content("The page you were looking for doesn't exist (404)")
  end
  
  it "should allow testing of the table" do
    DailyTable.any_instance.stubs(:fetch).returns(
              Ruport::Data::Table.new(:data => [["eggs","5"], ["milk","3 gallons"]],
                                      :column_names => %w[item amount])     
              )
    table = Factory(:table, :user => @daily_user)
    
    visit daily_table_path(table)
    
    page.should have_no_content("gallons")
    page.should have_no_content("amount")
    
    click_link "See Table Output"
    
    current_path.should == daily_table_path(table)
    page.should have_content("3 gallons")
    page.should have_content("eggs")
    page.should have_content("amount")
  end
  
  describe "Unarchiving" do
    it "should bring it back" do
      table = Factory(:table, :user => @daily_user, :archived => true)
      visit daily_table_path(table)
      page.should have_content("State: Archived")
    
      click_button("Unarchive")
      
      current_path.should == "/tables/#{table.id}"
      page.should have_content("Table has been unarchived.")
      page.should have_content("State: Active")
    end
  end
  
  describe "Archiving" do
    it "should allow me to archive a table with no reports" do
      table = Factory(:table, :user => @daily_user)
      visit daily_table_path(table)
      page.should have_content("State: Active")
    
      click_link("Archive")
      
      current_path.should == "/tables/#{table.id}/archive"
      page.should have_content("No reports based on this table.")
      click_button("Archive")
      
      current_path.should == "/tables/#{table.id}"
      page.should have_content("Table has been archived.")
      page.should have_content("State: Archived")
    end
    
    it "should not allow other users to archive it" do
      other = Factory(:table)
      visit archive_daily_table_path(other)
      page.should have_content("The page you were looking for doesn't exist (404)")
    end
  
    it "should allow me to delete a table with no reports" do
      table = Factory(:table, :user => @daily_user)
      visit daily_table_path(table)
      page.should have_content("State: Active")
      
      click_button("Delete")

      current_path.should == '/home'
      page.should have_content("Table has been deleted.")
    end
    
    it "should only allow archiving of tables with reports" do
      table = Factory(:table, :user => @daily_user)
      report = Factory(:report, :name => "Abc123", :user => @daily_user, :table => table)
      
      visit daily_table_daily_report_path(table, report)
      page.should have_content("State: Active")
      
      visit daily_table_path(table)
      page.should have_content("State: Active")
    
      click_link("Archive")
      
      current_path.should == "/tables/#{table.id}/archive"
      page.should have_content("Reports based on this table")
      page.should have_content("Abc123")
      click_button("Archive")
      
      current_path.should == "/tables/#{table.id}"
      page.should have_content("Table has been archived.")
      page.should have_content("State: Archived")
      
      visit daily_table_daily_report_path(table, report)
      page.should have_content("State: Archived")
    end
  end
  
end