require 'spec_helper'

class HasDataTest
  def self.serialize(*args)
  end
  
  include HasData
  
  attr_accessor :whatever_data
  has_data :whatever
end

describe HasDataTest do
  it "should define the json methods" do
    obj = HasDataTest.new
    obj.whatever_json.should be_nil
    
    obj.whatever_json = "{ \"test\": 1 }"
  
    obj.whatever_json.should == "{ \"test\": 1 }"
    
    obj.whatever_data.should == { "test" => 1 }    
  end
  
  it "should give the values from the hash" do
    obj = HasDataTest.new
    
    obj.whatever_data = { "other" => "ok" }
    obj.whatever_json.should == "{\n  \"other\": \"ok\"\n}"
  end
end