class Table < ActiveRecord::Base
  include SharedBehaviors
  
  belongs_to :user
  has_many :reports
  
  generate_guid :guid
  
  validates_presence_of :user
  validates_unique_presence_of :name
  validates_stripped_presence_of :metric_data
  validates_stripped_presence_of :metric

  validate :metric_known
  
  serialize :column_names, Array
  
  def sql?
    metric == "SqlQuery"
  end
  
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
      metric.constantize.display_name
    rescue Exception => e
      return "#{metric} (unknown)"
    end
  end
    
  protected
  def metric_known
    return if metric.blank?
    unless sql?
      errors.add(:metric, "is not known")
    end
  end
  
  def fetch_data
    metric.constantize.new(metric_data).result
  end
  
end