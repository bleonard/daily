class GenerateReportJob < Struct.new(:report_id, :requeue)

  def enqueue(job)
    job.report_id = self.report_id
  end

  def report
    @daily_report ||= DailyReport.find_by_id(report_id)
  end

  def perform
    return if report.nil?
    report.generate!
    report.queue_next! if requeue
  end

end
