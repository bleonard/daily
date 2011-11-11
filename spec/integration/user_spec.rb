require 'spec_helper'

describe "User" do
  it "should not allow user creation" do
    lambda { visit "/users/sign_up" }.should raise_error
  end
  
end