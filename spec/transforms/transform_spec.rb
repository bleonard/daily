require 'spec_helper'

describe Transform do
  describe "form properties" do
    it ".display_name" do
      Transform.display_name.should == "Transform"
    end
    it ".form_keys should efault to columns as the most common case" do
      Transform.form_keys.should == [:columns]
    end
  end
  
  describe ".transforms" do
    array = Transform.transforms
    array.include?(ColumnFilter).should == true
  end
  
  describe "#result" do
    it "should raise error" do
      lambda{ Transform.new.result }.should raise_error
    end
  end
end