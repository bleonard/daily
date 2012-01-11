class DailyTable < ActiveRecord::Base
  include SharedBehaviors
  
  belongs_to :user, :class_name => "DailyUser"
  has_many :reports, :class_name => "DailyReport", :foreign_key => "table_id"
  
  # just easier with declarative auth to also have this one
  has_many :daily_reports, :foreign_key => "table_id"
  
  generate_guid :guid
  
  validates_presence_of :user
  validates_unique_presence_of :name
  validates_stripped_presence_of :metric

  validate :metric_valid
  serialize :column_names, Array
  
  def result
    fetch
  end
  
  def fetch
    time = Time.now.to_i
    
    out = fetch_data
    out = apply_transform(out)

    atts = {}
    atts[:fetch_time_in_seconds] = Time.now.to_i - time
    atts[:column_names] = out.column_names
    self.attributes = atts
    save unless new_record?
    
    out
  end
  
  def test
    # ouputs html of the table
    begin
      fetch.to_html.html_safe
    rescue => e
      out = "#{e.message}"
      out += "\n\nTrace shown in development environment:\n#{e.backtrace.join("\n")}" if Rails.env.development?
      out.gsub("\n", "<br/>").html_safe
    end
  end
  
  def metric_name
    return "" if metric.blank?
    begin
      return metric.constantize.display_name
    rescue Exception => e
      return "#{metric} (unknown)"
    end
  end
    
  protected
  
  def metric_valid
    return if metric.blank?
    begin
      metric.constantize.get_data_errors(metric_data).each do |message|
        errors.add(:metric_data, message)
      end
    rescue Exception => e
      errors.add(:metric, "is not known")
    end
  end
  
  def fetch_data
    metric.constantize.new(metric_data).result
  end
  
end