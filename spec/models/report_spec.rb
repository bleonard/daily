require 'spec_helper'

describe Report do
  it { should belong_to :user }
  it { should belong_to :table }
  it { should validate_presence_of :user }
  it { should validate_presence_of :table }
  it { should validate_presence_of :formatter }
  it { should validate_presence_of :name }
  
  describe "filenames" do
    before do
      Report.any_instance.stubs(:guid_generate).returns("1234")
    end
    it "should generate a filename on create" do
      report = Factory.build(:report, :formatter => "csv")
      report.filename.should be_nil
      report.save.should == true
      report.filename.should == "1234.csv"
    end
    it "should not generate one if it has one" do
      report = Factory.build(:report, :formatter => "csv", :filename => "5678.csv")
      report.filename.should == "5678.csv"
      report.save.should == true
      report.filename.should == "5678.csv"
    end
    it "should not generate one if not new record" do
      report = Factory(:report)
      report.should_not be_new_record
      report.filename = ""
      report.save.should == false
      report.errors.full_messages.should == ["Filename can't be blank"]
    end
    it "should be able to update filename" do
      report = Factory(:report, :formatter => "csv")
      report.filename.should == "1234.csv"
      report.filename = "5678.csv"
      report.save.should == true
      report.reload.filename.should == "5678.csv"
    end
  end
end