require 'integration_helper'

describe "Applying Transforms" do
  before do
    @daily_user = Factory(:user)
    login_as @daily_user
  end

  it "should be available on a table" do
    data = Ruport::Data::Table.new(:data => [[1,2,3], [7,8,9]], :column_names => %w[first_column second_column third_column])
    DailyTable.any_instance.stubs(:fetch_data).returns(data)
    
    visit new_daily_table_path
    
    fill_in("Name", :with => "My Table")
    fill_in("Metric data", :with =>"Something")
    select("Column Filter", :from =>"Transform")
    fill_in("Transform json", :with =>'{ "columns":["first_column","third_column"] }')
    
    click_button("Create Table")
    
    page.should have_content("Table was successfully created.")
    page.should have_content('My Table')
    current_path.should == '/tables/1'
    
    click_link("See Table Output")
    
    page.should have_content('first_column')
    page.should have_content('third_column')
    page.should have_no_content('second_column')
  end
  
end