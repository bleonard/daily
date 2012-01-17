class DailyReport < ActiveRecord::Base
  include SharedBehaviors
  belongs_to :user, :class_name => "DailyUser"
  belongs_to :table, :class_name => "DailyTable"
  has_many :jobs, :class_name => "::Delayed::Job", :foreign_key => "report_id"
  
  has_data :formatter
  
  generate_guid :filename
  
  validates_presence_of :user
  validates_presence_of :table
  validates_unique_presence_of :name
  validates_stripped_presence_of :formatter

  before_validation :filename_extension_update

  after_save :ensure_job
  after_save :queue_now!, :if => :queue_job_now?
  
  after_save :delete_file!, :if => :archived?
  after_destroy :delete_file!
  
  def self.formatters
    Ruport::Controller::Table.formats.keys
  end
  
  def parent
    "files/#{table.guid}"
  end

  def localdir
    "#{Rails.root}/#{parent}"
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
  
  def delete_file!
    File.delete(localfile) if File.file?(localfile)
    true
  end
  
  def generate!
    Dir.mkdir(localdir) unless File.directory?(localdir)
    touch(:generate_started_at)
    data = table.result
    data = apply_transform(data)
    val = save_as!(data, localfile)
    touch(:generate_ended_at)
    val
  end
  
  def save_as!(data, path)
    tempfile = "#{Rails.root}/process/#{Time.now.to_i}_#{rand(9999999)}_#{rand(9999999)}.tmp"
    return false unless data.as(formatter.to_sym, (formatter_data || {}).merge(:file => tempfile))
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

  def archive
    self.archived = true
    save ? self : nil
  end
  
  def archive!
    self.archived = true
    save!
  end
  
  def unarchive
    self.archived = false
    save ? self : nil
  end
  
  protected
  
  def queue_job_now?
    return false if archived?
    filename_changed? or archived_changed?
  end

  def guid_append
    return "" if formatter.blank?
    ".#{formatter.strip}"
  end
  
  def calculate_next_gen_time
    Time.now + 1.hour
  end
  
  def ensure_job
    queue_next! if not archived? and jobs.reload.size == 0
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