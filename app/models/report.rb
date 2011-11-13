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

  def localdir
    "#{Rails.root}/public/#{parent}"
  end
  
  def localfile
    "#{localdir}/#{filename}"
  end
  
  def url(root)
    "#{root}#{parent}/#{filename}"
  end
  
  def file_exists?
    File.file?(localfile)
  end
  
  def generate!
    Dir.mkdir(localdir) unless File.directory?(localdir)
    table.generate!(formatter, localfile)
  end

  protected

  def guid_append
    return "" if formatter.blank?
    ".#{formatter.strip}"
  end

end