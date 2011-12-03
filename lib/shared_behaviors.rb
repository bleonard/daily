module SharedBehaviors
  def self.included(model)
    model.send :include, InstanceMethods
    model.send :extend, ClassMethods
    model.send :serialize, :transform_data, Hash
  end
  
  
  module InstanceMethods    
    def guid_generate
      key = "#{Time.now.to_i}::#{rand(999999999)}::#{attributes.values.join("::")}"
      Digest::MD5.hexdigest(key)
    end

    def transform_json
      return @transform_json if @transform_json
      return nil if transform_data.blank?
      JSON.pretty_generate(transform_data)
    end
    
    def transform_json=val
      @transform_data = val
      set_transform_json
    end

    def apply_transform(table)
      return table if transform.blank?
      t = transform.constantize.new(table, transform_data)
      t.result
    end
    
    protected
    
    def settable_guid
      prepend = respond_to?(:guid_prepend) ? guid_prepend : ""
      append = respond_to?(:guid_append) ? guid_append : ""
      "#{prepend}#{guid_generate}#{append}"
    end
    
    def generate_guid_if_needed
      return true unless new_record?
      val = send(self.class.guid_field)
      return true unless val.blank?
      send("#{self.class.guid_field}=", settable_guid)
    end
    
    def set_transform_json
      return unless defined?(@transform_data)
      self.transform_data = nil
      return if @transform_data.blank?
      begin
        self.transform_data = JSON.parse(@transform_data)
      rescue => ex
        self.errors.add(:transform_json, ex.message)
      end
    end
  end
  
  module ClassMethods
    def generate_guid(field)
      @guid_field = field.to_sym
      validates_presence_of @guid_field
      before_validation :generate_guid_if_needed
    end
    def guid_field
      @guid_field
    end
    
    def validates_stripped_presence_of(field)
      validates_presence_of field
      method = "strip_before_validation_#{field}"
      define_method method do
        return true if send(field).nil?
        send("#{field}=", send(field).strip)
      end
      before_validation method
    end
    
    def validates_unique_presence_of(field)
      validates_stripped_presence_of field
      validates_uniqueness_of field, :case_sensitive => false
    end
  end
  
end
