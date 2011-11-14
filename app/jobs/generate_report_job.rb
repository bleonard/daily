class GenerateReportJob < Struct.new(:report_id, :requeue)

  def report
    @report ||= Report.find_by_id(report_id)
  end

  def perform
    return if report.nil?
    report.generate!
    report.queue_next! if requeue
  end

end
