require 'spec_helper'

describe Ruport::Formatter::JSON do
  it "should output json when no column names" do
    actual = Ruport::Controller::Table.render_json { |r|
      r.data = Table([], :data => [[1,2,3],[4,5,nil]])
    }          
    actual.should == "[\n  {\"0\":1,\"1\":2,\"2\":3},\n  {\"0\":4,\"1\":5,\"2\":null}\n]"
  end
  
  it "should output json with columns names" do
    actual = Ruport::Controller::Table.render_json { |r| 
      r.data = Table(%w[a b c], :data => [[1,2,3],[4,5,6]])
    }
    actual.should == "[\n  {\"a\":1,\"b\":2,\"c\":3},\n  {\"a\":4,\"b\":5,\"c\":6}\n]"
  end
end