class Report < ActiveRecord::Base
  include SharedBehaviors
  belongs_to :user
  belongs_to :table
  has_many :jobs, :class_name => "::Delayed::Job"
  
  generate_guid :filename
  
  validates_presence_of :user
  validates_presence_of :table
  validates_unique_presence_of :name
  validates_stripped_presence_of :formatter

  before_validation :filename_extension_update

  after_save :ensure_job
  after_save :queue_now!, :if => :filename_changed?
  
  def self.formatters
    Ruport::Controller::Table.formats.keys
  end
  
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
    root += "/" unless root[-1, 1] == "/"
    "#{root}#{parent}/#{filename}"
  end
  
  def file_exists?
    File.file?(localfile)
  end
  
  def generate!
    Dir.mkdir(localdir) unless File.directory?(localdir)
    touch(:generate_started_at)
    data = table.result
    val = save_as!(data, localfile)
    touch(:generate_ended_at)
    val
  end
  
  def save_as!(data, path)
    tempfile = "#{Rails.root}/process/#{Time.now.to_i}_#{rand(9999999)}_#{rand(9999999)}.tmp"
    return false unless data.as(formatter.to_sym, :file => tempfile)
    return false unless File.file?(tempfile)
    File.rename(tempfile, path)
    File.file?(path)
  end
  
  def queue_next!
    job = GenerateReportJob.new(id, true)
    Delayed::Job.enqueue :payload_object => job, 
                         :priority => 10,
                         :run_at => calculate_next_gen_time,
                         :report_id => id
  end

  def queue_now!
    job = GenerateReportJob.new(id, false)
    Delayed::Job.enqueue :payload_object => job, 
                         :priority => 0,
                         :report_id => id
  end
  
  def next_job
    jobs.by_priority.first
  end

  protected

  def guid_append
    return "" if formatter.blank?
    ".#{formatter.strip}"
  end
  
  def calculate_next_gen_time
    Time.now + 1.hour
  end
  
  protected
  
  def ensure_job
    queue_next! if jobs.reload.size == 0
    true
  end
  
  def filename_extension_update
    return true if filename_changed?
    return true unless formatter_changed?
    pieces = filename.split(".")
    if pieces.size > 1
      pieces[-1] = formatter.to_s
      self.filename = pieces.join(".")
    end
    true
  end

end