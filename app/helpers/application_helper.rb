module ApplicationHelper
  def title(text)
    @title = text
  end
  
  def page_title
    @title || "Daily"
  end
  
  def header_title
    @title
  end
  
  def seconds_sentence(time)
    return "Running now..." if time < 0
    return "Less than a second" if time == 0
    return "1 second" if time == 1
    "#{time} seconds"
  end
  
  def report_time_run(report)
    return "Unknown" if report.generate_started_at.nil?
    return "Unknown" if report.generate_ended_at.nil?
    
    time = report.generate_ended_at.to_i - report.generate_started_at.to_i
    seconds_sentence(time)
  end
  
  def report_time_ago(report)
    return "None" unless report.file_exists?
    return "Unknown" if report.generate_ended_at.nil?
    
    exact = report.generate_ended_at.strftime("%T %Z")
    return "Future? (#{exact})" if report.generate_ended_at > Time.now
    "#{time_ago_in_words(report.generate_ended_at)} ago (#{exact})"
  end
  
  def table_time_run(table)
    return "Unknown" if table.fetch_time_in_seconds.nil?
    seconds_sentence(table.fetch_time_in_seconds)
  end
end
