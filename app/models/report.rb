class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :table
  
  validates_presence_of :user
  validates_presence_of :table
  validates_presence_of :name
  validates_presence_of :filename
  validates_presence_of :formatter
  
  before_validation :generate_filename_if_needed
  
  def make_guid
    key = "#{Time.now.to_i}::#{rand(999999999)}::#{attributes.values.join("::")}"
    Digest::MD5.hexdigest(key)
  end
  
  protected
  
  def generate_filename_if_needed
    return true unless new_record?
    return true unless filename.blank?
    self.filename = "#{make_guid}.#{formatter}"
  end
end