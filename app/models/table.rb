class Table < ActiveRecord::Base
  include SharedBehaviors
  
  belongs_to :user
  has_many :reports
  
  validates_presence_of :user
  validates_stripped_presence_of :name
  validates_stripped_presence_of :data
  validates_stripped_presence_of :data_type
  
  validates_uniqueness_of :name, :case_sensitive => false
    
  validate :data_type_known
  
  def sql?
    data_type == "sql"
  end
  
  def fetch
    # TODO: method to make test easier?
    return fetch_sql if sql?
    Ruport::Data::Table.new
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
  
  def fetch_sql
    Ruport::Query.new(data).result
  end
  
end