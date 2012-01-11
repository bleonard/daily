require 'spec_helper'

describe Table do
  it { should belong_to :user }
  it { should have_many :reports }
  it { should validate_presence_of :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :metric }
  
  describe "Validations" do
    it "should have a valid data type" do
      Table.new(:metric => nil).should have(1).error_on(:metric)
      Table.new(:metric => "").should have(1).error_on(:metric)
      Table.new(:metric => "something").should have(1).error_on(:metric)
      Table.new(:metric => "sql").should have(1).error_on(:metric)
      Table.new(:metric => "SqlQuery").should have(0).error_on(:metric)
    end
    
    it "should require data if needed" do
      Table.new(:metric => "SqlQuery").should have(1).error_on(:metric_data)
      Table.new(:metric => "SqlQuery", :metric_data => "something").should have(0).error_on(:metric_data)
      
      SqlQuery.stubs(:get_data_errors)
      Table.new(:metric => "SqlQuery").should have(0).error_on(:metric_data)
      
      SqlQuery.expects(:get_data_errors).returns ["one", "two"]
      Table.new(:metric => "SqlQuery").should have(2).error_on(:metric_data)
    end
  end

  describe "uniqueness" do
    it "should cehck uniqueness" do
      other = Factory(:table, :name => "Whatever")
      Table.new(:name => "Whatever").should have(1).error_on(:name)
      Table.new(:name => "whatever").should have(1).error_on(:name)
      Table.new(:name => "whatever ").should have(1).error_on(:name)
      Table.new(:name => "   Whatever").should have(1).error_on(:name)
      Table.new(:name => "Else").should have(0).error_on(:name)
    end
  end
  
  describe "#fetch" do
    context "on a saved record" do
      before do
        data = Ruport::Data::Table.new(:data => [[1,2,3], [7,8,9]], :column_names => %w[a b c])
        @table = Factory(:table)
        @table.stubs(:fetch_data).returns(data)
      end
      it "should store the time to process" do
        @table.fetch_time_in_seconds.should be_nil
        @table.fetch
        @table.reload.fetch_time_in_seconds.should_not be_nil
      end
      it "should store column names" do
        @table.column_names.should == []
        @table.fetch
        @table.reload.column_names.should == ["a", "b", "c"]
      end
      
      it "should apply a transform afterwards if available" do
        data = Ruport::Data::Table.new(:data => [[1,2,3], [7,8,9]], :column_names => %w[a b c])
        @table = Factory(:table, :transform => "ColumnFilter", :transform_data => {:columns => [ "a", "c"]} )
        @table.stubs(:fetch_data).returns(data)

        out = @table.result
        out.column_names.should == ["a", "c"]  
        out.size.should == 2
        out[0][0].should == 1
        out[0][1].should == 3
        out[0][2].should be_nil

        @table.column_names.should == ["a","c"]
      end
    end
    context "on a new record" do
      it "should also update attributes but in memory" do
        data = Ruport::Data::Table.new(:data => [[1,2,3], [7,8,9]], :column_names => %w[a b c])
        @table = Table.new
        @table.stubs(:fetch_data).returns(data)
        @table.fetch
        @table.should be_new_record
        @table.column_names.should == ["a", "b", "c"]
      end
    end
  end

  
end
