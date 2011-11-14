class Report < ActiveRecord::Base
  include SharedBehaviors
  belongs_to :user
  belongs_to :table
  
  generate_guid :filename
  
  validates_presence_of :user
  validates_presence_of :table
  validates_unique_presence_of :name
  validates_stripped_presence_of :formatter

  after_create :queue_next!
  after_save :queue_now!, :if => :filename_changed?

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
    touch(:generate_started_at)
    val = table.generate!(formatter, localfile)
    touch(:generate_ended_at)
    val
  end
  
  def queue_next!
    job = GenerateReportJob.new(id, true)
    Delayed::Job.enqueue :payload_object => job, :run_at => calculate_next_gen_time, :priority => 10
  end

  def queue_now!
    job = GenerateReportJob.new(id, false)
    Delayed::Job.enqueue :payload_object => job, :priority => 0
  end

  protected

  def guid_append
    return "" if formatter.blank?
    ".#{formatter.strip}"
  end
  
  def calculate_next_gen_time
    Time.now + 1.hour
  end

end