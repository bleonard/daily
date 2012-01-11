require 'spec_helper'

describe SqlQuery do
  describe "form properties" do
    it ".display_name" do
      SqlQuery.display_name.should == "SQL Query"
    end
    it ".form_keys should default to columns as the most common case" do
      SqlQuery.form_keys.should == []
    end
  end
  
  describe ".get_data_errors" do
    it "should return error on blank" do
      SqlQuery.get_data_errors("").should == ["can't be blank"]
      SqlQuery.get_data_errors(nil).should == ["can't be blank"]
      SqlQuery.get_data_errors("  ").should == ["can't be blank"]
      SqlQuery.get_data_errors("something").should == []
    end
  end
end