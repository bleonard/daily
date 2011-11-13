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
  
  def generate!(format, path)
    tempfile = "#{Rails.root}/process/#{Time.now.to_i}_#{rand(9999999)}_#{rand(9999999)}.tmp"
    return false unless fetch.as(format.to_sym, :file => tempfile)
    return false unless File.file?(tempfile)
    File.rename(tempfile, path)
    File.file?(path)
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