require 'spec_helper'

describe MovingAverage do
  describe "form properties" do
    it ".display_name" do
      MovingAverage.display_name.should == "Moving Average"
    end
    it ".form_keys" do
      MovingAverage.form_keys.should =~ [:columns, :days, :date]
    end
  end
  describe "num_days" do
    it "should be the one passed in" do
      table = Ruport::Data::Table.new( :data => [ [1,Time.now], [2,Time.now, 1.minute.ago]], 
                                        :column_names => %w[val given_time])
      transform = MovingAverage.new(table, { :columns => [ "val" ], :date => "given_time", :days => "5"})
      transform.num_days.should == 5
    end
    it "should default to 7" do
      table = Ruport::Data::Table.new( :data => [ [1,Time.now], [2,Time.now, 1.minute.ago]], 
                                        :column_names => %w[val given_time])
      transform = MovingAverage.new(table, { :columns => [ "val" ], :date => "given_time"})
      transform.num_days.should == 7
    end
  end
  describe "date_column" do
    it "should be the one passed in" do
      table = Ruport::Data::Table.new( :data => [ [1,Time.now, 1.minute.ago, 2.minutes.ago],
                                                  [2,Time.now, 2.minutes.ago, 3.minutes.ago]], 
                                        :column_names => %w[val given_time created_at updated_at])
      transform = MovingAverage.new(table, { :columns => [ "val" ], :date => "given_time"})
      transform.date_column.should == "given_time"
    end
    it "should default to created_at" do
      table = Ruport::Data::Table.new( :data => [ [1,Time.now, 1.minute.ago, 2.minutes.ago],
                                                  [2,Time.now, 2.minutes.ago, 3.minutes.ago]], 
                                        :column_names => %w[val given_time created_at updated_at])
      transform = MovingAverage.new(table, { :columns => [ "val" ]})
      transform.date_column.should == "created_at"
    end
    it "then should default to updated_at" do
      table = Ruport::Data::Table.new( :data => [ [1,Time.now, 1.minute.ago, 2.minutes.ago],
                                                  [2,Time.now, 2.minutes.ago, 3.minutes.ago]], 
                                        :column_names => %w[val given_time xcreated_at updated_at])
      transform = MovingAverage.new(table, { :columns => [ "val" ]})
      transform.date_column.should == "updated_at"
    end
    it "then it would be the first time column" do
      table = Ruport::Data::Table.new( :data => [ [1,Time.now, 1.minute.ago, 2.minutes.ago],
                                                  [2,Time.now, 2.minutes.ago, 3.minutes.ago]], 
                                        :column_names => %w[val given_time xcreated_at xupdated_at])
      transform = MovingAverage.new(table, { :columns => [ "val" ]})
      transform.date_column.should == "given_time"
    end
    it "should return nil when no time columns" do
      table = Ruport::Data::Table.new( :data => [ [1], [2]], :column_names => %w[val])
      transform = MovingAverage.new(table, { :columns => [ "val" ]})
      transform.date_column.should be_nil
    end
  end
  
  describe "#result" do
    it "should calculates the averages and pass thru the sums" do
      table = Ruport::Data::Table.new( :column_names => %w[val time other more],
                                       :data => [ [1, Time.zone.parse("01/01/2011"), 0, 2], 
                                                  [2, Time.zone.parse("01/01/2011"), 2, 8],
                                                  [11, Time.zone.parse("01/03/2011"), 2, 11],
                                                  [-8, Time.zone.parse("01/01/2011"), 11, 16],
                                                ])
      transform = MovingAverage.new(table, { :columns => [ "val", "other" ]})
      result = transform.result
      result.to_txt.should == <<-TABLE
+---------------------------------------------+
|    time    | val  | other | val_7 | other_7 |
+---------------------------------------------+
| 2011-01-01 | -5.0 |  13.0 |  -5.0 |    13.0 |
| 2011-01-02 |    0 |     0 |  -2.5 |     6.5 |
| 2011-01-03 | 11.0 |   2.0 |   2.0 |     5.0 |
+---------------------------------------------+
TABLE
    end
  end
  
  describe "#day_data" do
    it "should average it up per day" do
      table = Ruport::Data::Table.new( :column_names => %w[val time other more],
                                       :data => [ [1, Time.zone.parse("01/01/2011"), 0, 2], 
                                                  [2, Time.zone.parse("01/01/2011"), 2, 8],
                                                  [10, Time.zone.parse("01/03/2011"), 2, 10],
                                                  [-8, Time.zone.parse("01/01/2011"), 3, 16],
                                                ])
      transform = MovingAverage.new(table, { :columns => [ "val", "other" ]})
      data = transform.send(:day_data)
      data.should == {  "days"=>
                            { Date.new(2011,1,1)=>{"val"=>-5.0, "other"=>5.0}, 
                              Date.new(2011,1,3)=>{"val"=>10.0, "other"=>2.0}
                            }, 
                        "latest"=>Date.new(2011,1,3), 
                        "earliest"=>Date.new(2011,1,1)
                      }
    end
    
  end
  
  describe ".to_day" do
    it "should normalize to local day" do
      MovingAverage.to_day(Time.parse("2011-12-01 12:00")).should == Date.new(2011,12,1)
    end
  end

end