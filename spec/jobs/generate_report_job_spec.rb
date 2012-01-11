require 'spec_helper'

describe GenerateReportJob do
  it "should generate the file" do
    report = Factory(:report)
    DailyReport.any_instance.expects(:generate!)
    job = GenerateReportJob.new(report.id, true)
    job.perform
  end
  
  it "should requeue when told" do
    report = Factory(:report)
    job = GenerateReportJob.new(report.id, true)
    job.stubs(:report).returns(report)
    
    report.expects(:generate!)
    report.expects(:queue_next!).once
    
    job.perform
  end
  
  it "should not requeue when not told" do
    report = Factory(:report)
    job = GenerateReportJob.new(report.id, false)
    job.stubs(:report).returns(report)
    
    report.expects(:generate!)
    report.expects(:queue_next!).never
    
    job.perform
  end
end