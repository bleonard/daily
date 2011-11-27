class Table < ActiveRecord::Base
  include SharedBehaviors
  
  belongs_to :user
  has_many :reports
  
  generate_guid :guid
  
  validates_presence_of :user
  validates_unique_presence_of :name
  validates_stripped_presence_of :data
  validates_stripped_presence_of :data_type

  validate :data_type_known
  
  serialize :column_names, Array
  
  def sql?
    data_type == "sql"
  end
  
  def results
    fetch
  end
  
  def fetch
    time = Time.now.to_i
    out = fetch_data
    
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
    
  protected
  def data_type_known
    return if data_type.blank?
    unless sql?
      errors.add(:data_type, "is not known")
    end
  end
  
  def fetch_data
    return Ruport::Query.new(data).result if sql?
    Ruport::Data::Table.new
  end
  
end