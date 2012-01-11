class Metric
  def self.metrics
    DailyConfig.load_classes if Rails.env.development?
    subclasses
  end
  
  def self.display_name
    name.demodulize.underscore.humanize.titleize
  end
  
  def self.form_keys
    []  # override to get more / different
  end
  
  def self.validates_presence_of_data
    @validates_presence_of_data = true
  end
  
  def self.get_data_errors(data)
    return ["can't be blank"] if @validates_presence_of_data and data.blank?
    validate_data(data) || []
  end
  
  def self.validate_data(data)
    []
  end
    
  attr_accessor :data
  def initialize(data)
    self.data = data
  end

  def setting(key, default = nil)
    val = settings[key.to_sym]
    val.blank? ? default : val
  end

  def result
    raise("Metrics must override result")
  end
end
