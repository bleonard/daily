require 'integration_helper'

describe "Adding Tables" do
  before do
    @daily_user = Factory(:user)
    login_as @daily_user
  end
  
  it "should allow user to create a Table" do
    visit "/"
    click_link "New Table"
    current_path.should == '/tables/new'
    
    fill_in("Name", :with => "My Table")
    fill_in("Metric data", :with =>"Something")
    
    click_button("Create Table")
    
    page.should have_content("Table was successfully created.")
    page.should have_content('My Table')
    current_path.should == '/tables/1' 
  end
  
  it "should display validations and then work" do
    Factory(:table, :name => "whatever1", :user => @daily_user)
    
    visit "/tables/new"
    fill_in("Name", :with => "whatever1")
    click_button("Create Table")
    
    current_path.should == '/tables'
    page.should have_content("can't be blank")
    page.should have_content("has already been taken")
    
    fill_in("Name", :with => "whatever2")
    fill_in("Metric data", :with =>"Something")
    
    click_button("Create Table")
    
    page.should have_content("Table was successfully created.")
    current_path.should == '/tables/2'
    page.should have_content('whatever2')
    
    visit "/"
    page.should have_content('whatever1')
    page.should have_content('whatever2')
  end
  
end