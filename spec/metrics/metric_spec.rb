require 'spec_helper'

class TestMetric1 < Metric
  def column_names
    ["one", "two"]
  end
  def add_rows(table)
    table << [1, 2]
  end
end

class TestMetric2 < Metric
  def add_rows(table)
    table << [1, 2]
  end
end

class TestMetric3 < Metric
  def column_names
    ["one", "two"]
  end
end

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
    it "should default to empty" do
      table = Metric.new("").result
      table.size.should == 0
      table.column_names.should == []
    end
    it "make a table with column names" do
      table = TestMetric1.new("").result
      table.size.should == 1
      table.column_names.should == ["one", "two"]
    end
    it "make a table without column names" do
      table = TestMetric2.new("").result
      table.size.should == 1
      table.column_names.should == []
    end
    it "should make a talble without data" do
      table = TestMetric3.new("").result
      table.size.should == 0
      table.column_names.should == ["one", "two"]
    end
  end
end