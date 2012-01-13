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
  
  def before_table
    
  end
  
  def before_creation
    
  end
  
  def column_names
    []
  end

  def table_options
    out = {}
    cols = self.column_names
    out[:column_names] = cols if cols and not cols.empty?
    out
  end
  
  def create_table
    Ruport::Data::Table.new(table_options)
  end
  
  def after_creation(table)
    
  end
  
  def before_rows(table)
    
  end
  
  def add_rows(table)
    
  end
  
  def after_rows(table)
    
  end
  
  def after_table(table)
    
  end
  
  def result
    before_table
    before_creation
    out = create_table
    after_creation(out)
    before_rows(out)
    add_rows(out)
    after_rows(out)
    after_table(out)
    out
  end
end
