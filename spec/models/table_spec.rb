require 'spec_helper'

describe Table do
  it { should belong_to :user }
  it { should have_many :reports }
  it { should validate_presence_of :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :data }
  it { should validate_presence_of :data_type }
  
  describe "Validations" do
    it "should have a valid data type" do
      Table.new(:data_type => nil).should have(1).error_on(:data_type)
      Table.new(:data_type => "").should have(1).error_on(:data_type)
      Table.new(:data_type => "something").should have(1).error_on(:data_type)
      Table.new(:data_type => "sql").should have(0).error_on(:data_type)
    end
  end

  describe "#sql?" do
    it "should return true if data_type is that" do
      Table.new(:data_type => "sql").should be_sql
      Table.new(:data_type => nil).should_not be_sql
      Table.new(:data_type => "").should_not be_sql
      Table.new(:data_type => "SQL").should_not be_sql
      Table.new(:data_type => "else").should_not be_sql
    end
  end
  
end
