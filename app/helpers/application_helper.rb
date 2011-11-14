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
  
  def display_time(time)
    seconds = Time.now.to_i - time.to_i
    
    if seconds.abs < 10
      out = "Now"
    elsif seconds > 0
      out = "#{time_ago_in_words(time)} ago"
    else
      out = "#{time_ago_in_words(time)} from now"
    end
    out += " (#{time.strftime("%T %Z")})"
  end
  
  def report_time_run(report)
    return "Unknown" if report.generate_started_at.nil?
    return "Unknown" if report.generate_ended_at.nil?
    
    time = report.generate_ended_at.to_i - report.generate_started_at.to_i
    seconds_sentence(time)
  end
  
  def report_time_next(report)
    job = report.next_job
    return "Not scheduled" if job.nil?
    return "Running now..." if job.locked_at.present?
    display_time(job.run_at)
  end
  
  def report_time_ago(report)
    return "None" unless report.file_exists?
    return "Unknown" if report.generate_ended_at.nil?
    display_time(report.generate_ended_at)
  end
  
  def table_time_run(table)
    return "Unknown" if table.fetch_time_in_seconds.nil?
    seconds_sentence(table.fetch_time_in_seconds)
  end
end
