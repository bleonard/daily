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
end