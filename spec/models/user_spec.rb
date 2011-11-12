require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :tables }
  it { should have_many :reports }
  
  it "should be created from factory" do
    Factory(:user).should_not be_new_record
  end
end
