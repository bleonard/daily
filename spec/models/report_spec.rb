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
    it "should change the filename if there is an extension and the formatter changes" do
      report = Factory(:report, :formatter => "csv")
      report.filename.should == "1234.csv"
      report.formatter = "html"
      report.save.should == true
      report.reload.filename.should == "1234.html"
    end
    it "should not change the filename if the formatter does not change" do
      report = Factory(:report, :formatter => "csv")
      report.filename.should == "1234.csv"
      report.filename = "1234.xls"
      report.save.should == true
      report.reload.filename.should == "1234.xls"
    end
    it "should not require an extension" do
      report = Factory(:report, :formatter => "csv")
      report.filename.should == "1234.csv"
      report.filename = "5678"
      report.save.should == true
      report.reload.filename.should == "5678"
    end
    it "should not require an extension and not change when formatter changes" do
      report = Factory(:report, :formatter => "csv", :filename => "5678")
      report.filename.should == "5678"
      report.formatter = "html"
      report.save.should == true
      report.reload.filename.should == "5678"
    end
    it "should leave the filename if both change" do
      report = Factory(:report, :formatter => "csv")
      report.filename.should == "1234.csv"
      report.formatter = "html"
      report.filename = "5678.else"
      report.save.should == true
      report.reload.filename.should == "5678.else"
    end
  end
  
  describe "#generate!" do
    it "should all save_as with the table data"
  end
  
  describe "#save_as!" do
    it "should save the report to disk"
  end
  
  describe "automatic queueing" do
    it "should queue on create" do
      report = Factory.build(:report)
      report.expects(:queue_now!).once
      report.expects(:queue_next!).once
      report.save.should == true
    end
    
    it "should queue on filename change" do
      report = Factory(:report)
      report.expects(:queue_now!).once
      report.expects(:queue_next!).never
      report.filename = "something_else.html"
      report.save.should == true
    end
    
    it "should not queue on normal udpate" do
      report = Factory(:report)
      report.expects(:queue_now!).never
      report.expects(:queue_next!).never
      report.name = "something else name"
      report.save.should == true
    end
    
    it "should make sure there is a job on save" do
      report = Factory(:report)
      Delayed::Job.delete_all
      report.expects(:queue_now!).never
      report.expects(:queue_next!).once
      report.name = "something else name"
      report.save.should == true
    end
    
  end
  
  describe "#queue_now!" do
    it "should make the delayed job now" do
       report = Factory(:report)

       Timecop.freeze do
         expect { report.queue_now! }.should change(Delayed::Job, :count).by(1)

         job = Delayed::Job.last

         payload = job.payload_object
         payload.report_id.should == report.id
         payload.requeue.should == false

         job.run_at.should == Time.now
         job.priority.should == 0
         job.report_id.should == report.id
       end
     end
  end
  
  describe "#queue_next!" do
    it "should make the delayed job a hour in the future" do
      report = Factory(:report)
      
      Timecop.freeze do
        expect { report.queue_next! }.should change(Delayed::Job, :count).by(1)
      
        job = Delayed::Job.last
      
        payload = job.payload_object
        payload.report_id.should == report.id
        payload.requeue.should == true
        
        job.run_at.should == 1.hour.from_now
        job.priority.should == 10
        job.report_id.should == report.id
      end
    end
  end
end