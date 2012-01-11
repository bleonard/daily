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
  
end