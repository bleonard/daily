class Metric
  def self.metrics
    subclasses
  end
  
  def self.display_name
    name.demodulize.underscore.humanize.titleize
  end
  
  def self.form_keys
    []  # override to get more / different
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
