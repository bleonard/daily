class Report < ActiveRecord::Base
  include SharedBehaviors
  belongs_to :user
  belongs_to :table
  
  generate_guid :filename
  
  validates_presence_of :user
  validates_presence_of :table
  validates_unique_presence_of :name
  validates_stripped_presence_of :formatter

  def parent
    "files/#{table.guid}"
  end

  def path
    "#{parent}/#{filename}"
  end
  
  def url(root)
    "#{root}#{path}"
  end
  
  def generate!
    pub = "#{Rails.root}/public"
    dir = "#{pub}/#{parent}"
    Dir.mkdir(dir) unless File.directory?(dir)
    table.generate!(formatter, "#{pub}/#{path}")
  end

  protected

  def guid_append
    return "" if formatter.blank?
    ".#{formatter.strip}"
  end

end