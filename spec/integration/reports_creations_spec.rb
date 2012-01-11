require 'integration_helper'

describe "Adding Reports" do
  before do
    @daily_user = Factory(:user)
    login_as @daily_user
  end
  
  it "should be made from a table" do
    table = Factory(:table, :user => @daily_user, :name => "Something1")
    table.id.should == 1
    
    visit daily_table_path(table)
    
    click_link "New report from this table"
    
    current_path.should == "/tables/1/reports/new"
    page.should have_content("New Report")
    page.should have_content("Table: Something1")
    page.should have_no_content("Filename")
    
    fill_in("Name", :with => "My Report")
    select('csv', :from => "Formatter")
    
    click_button("Create Report")
    
    current_path.should == "/tables/1/reports/1"
    page.should have_content("My Report")
    
    click_link("Edit")
    current_path.should == "/tables/1/reports/1/edit"
    
    page.should have_content("Filename")

  end
  
end