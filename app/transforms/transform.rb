class Transform
  def self.transforms
    DailyConfig.load_classes if Rails.env.development?
    subclasses
  end
  
  def self.display_name
    name.demodulize.underscore.humanize.titleize
  end
  def self.form_keys
    [:columns]  # override to get more / different
  end
    
  attr_accessor :table
  attr_accessor :settings
  def initialize(table, settings)
    self.table = table
    self.settings = (settings || {}).symbolize_keys
  end

  def setting(key, default = nil)
    val = settings[key.to_sym]
    val.blank? ? default : val
  end

  def columns
    setting(:columns, []).collect(&:to_s)
  end

  def result
    raise("Transforms must override result")
  end
end
