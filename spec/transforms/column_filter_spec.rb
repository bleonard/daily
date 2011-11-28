require 'spec_helper'

describe Transform::ColumnFilter do
  describe "form properties" do
    it ".display_name" do
      Transform::ColumnFilter.display_name.should == "Column Filter"
    end
    it ".form_keys" do
      Transform::ColumnFilter.form_keys.should == [:columns]
    end
  end
  describe "#result" do
    it "should only show the specified columns" do
      table = Ruport::Data::Table.new(:data => [[1,2,3,4], [7,8,9,10]], :column_names => %w[a b c d])
      transform = Transform::ColumnFilter.new(table, { :columns => [ "a", "c"]})
      
      table.column_names.should == ["a", "b", "c", "d"]
      table.size.should == 2
      table[0][0].should == 1
      table[0][1].should == 2
      table[0][2].should == 3
      table[0][3].should == 4
      
      out = transform.result
      out.column_names.should == ["a", "c"]  
      out.size.should == 2
      out[0][0].should == 1
      out[0][1].should == 3
      out[0][2].should be_nil
    end
  end
end