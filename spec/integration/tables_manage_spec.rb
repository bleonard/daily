require 'integration_helper'

describe "Managing Tables" do
  before do
    @user = Factory(:user)
    login_as @user
  end

  it "should not allow editing of a table that is not mine" do
    other = Factory(:table)
    visit edit_table_path(other)
    page.should have_content("The page you were looking for doesn't exist (404)")
  end
  
end