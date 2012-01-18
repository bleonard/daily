require 'spec_helper'

describe Ruport::Formatter::Png do
  it "should fetch a chart with a simple table" do
    #data = Ruport::Data::Table.new(:data => [[1,2,3], [7,8,9]], :column_names => %w[first_column second_column])
    #tempfile = "#{Rails.root}/process/test_#{Time.now.to_i}_#{rand(9999999)}_#{rand(9999999)}.tmp"
    #data.as(:png, :file => tempfile)
  end
  
  describe "#google_url" do
    it "should output one" do
      png = Ruport::Formatter::Png.new
      png.data = Ruport::Data::Table.new(:data => [[1,2], [7,8]], :column_names => %w[first_column second_column])
      png.google_hash.should == {:data => [[1,7], [2,8]], :legend => ["first_column", "second_column"]}
      png.google_url.should == "http://chart.apis.google.com/chart?chd=s:H2,P9&chdl=first_column%7Csecond_column&cht=lc&chs=300x200&chxr=0,1,7%7C1,2,8"
    end
  end
  
  describe "#google_hash" do
    # http://googlecharts.rubyforge.org/
    # Gchart.line(:size => '200x300', 
    #            :title => "example title",
    #            :bg => 'efefef',
    #            :legend => ['first data set label', 'second data set label'],
    #            :data => [10, 30, 120, 45, 72])
    
    it "should build up the data" do
      png = Ruport::Formatter::Png.new
      # these are in rows
      png.data = Ruport::Data::Table.new(:data => [[1,2], [7,8]], :column_names => %w[first_column second_column])
      
      # and need to be converted to series
      png.google_hash.should == {:data => [[1,7], [2,8]], :legend => ["first_column", "second_column"]}
    end
    
    it "should pass through other data" do
      png = Ruport::Formatter::Png.new
      png.options.size = "200x300"
      png.data = Ruport::Data::Table.new(:data => [[1,2], [7,8]], :column_names => %w[first_column second_column])
      png.google_hash.should == {:data => [[1,7], [2,8]], :legend => ["first_column", "second_column"], :size => "200x300"}
    end
    
    it "should be able to leave off the legend" do
      png = Ruport::Formatter::Png.new
      png.options.legend = false
      png.data = Ruport::Data::Table.new(:data => [[1,2], [7,8]], :column_names => %w[first_column second_column])
      png.google_hash.should == {:data => [[1,7], [2,8]]}
    end
    
    it "should output empty data" do
      png = Ruport::Formatter::Png.new
      # these are in rows
      png.data = Ruport::Data::Table.new(:data => [], :column_names => %w[first_column second_column])
      
      # and need to be converted to series
      png.google_hash.should == {:data => [[], []], :legend => ["first_column", "second_column"]}
    end
    
    it "should allow less columns" do
      png = Ruport::Formatter::Png.new
      png.options.columns = ["second_column"]
      png.data = Ruport::Data::Table.new(:data => [[1,2], [7,8]], :column_names => %w[first_column second_column])
      png.google_hash.should == {:data => [[2,8]], :legend => ["second_column"]}
    end
  end

  describe "#google_type" do
    it "should default to lines" do
      png = Ruport::Formatter::Png.new
      png.google_type.should == "line"
    end
    it "should use the passed in options" do
      png = Ruport::Formatter::Png.new
      png.options.chart_type = "BAR"
      png.google_type.should == "bar"
    end
  end
end