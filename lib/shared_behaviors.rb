module SharedBehaviors
  def self.included(model)
    model.send :include, InstanceMethods
    model.send :extend, ClassMethods
  end
  
  
  module InstanceMethods
    def generate_guid_if_needed
      return true unless new_record?
      val = send(self.class.guid_field)
      return true unless val.blank?
      send("#{self.class.guid_field}=", settable_guid)
    end
    
    def guid_generate
      key = "#{Time.now.to_i}::#{rand(999999999)}::#{attributes.values.join("::")}"
      Digest::MD5.hexdigest(key)
    end
    
    protected
    
    def settable_guid
      prepend = respond_to?(:guid_prepend) ? guid_prepend : ""
      append = respond_to?(:guid_append) ? guid_append : ""
      "#{prepend}#{guid_generate}#{append}"
    end
  
  end
  
  module ClassMethods
    def generate_guid(*args)
      @guid_field = args.first.to_sym
      validates_presence_of @guid_field
      before_validation :generate_guid_if_needed
    end
    def guid_field
      @guid_field
    end
  end
  
end
