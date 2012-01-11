require 'spec_helper'

describe Metric do  
  describe "form properties" do
    it ".display_name" do
      Metric.display_name.should == "Metric"
    end
    it ".form_keys should efault to columns as the most common case" do
      Metric.form_keys.should == []
    end
  end
  
  describe ".get_data_errors" do
    it "should return no errors" do
      Metric.get_data_errors("").should == []
    end
  end
  
  describe ".metrics" do
    array = Metric.metrics
    array.include?(SqlQuery).should == true
  end
  
  describe "#result" do
    it "should raise error" do
      lambda{ Metric.new.result }.should raise_error
    end
  end
end