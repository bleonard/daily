module HasData
  def self.included(model)
    model.send :include, InstanceMethods
    model.send :extend, ClassMethods
  end
  
  
  module InstanceMethods    

  end
  
  module ClassMethods
    def has_data field
      attribute = "#{field}_data"
      method = "#{field}_json"
      valid = "#{field}_json_check"
      
      serialize attribute, Hash
      
      define_method method do
        val = instance_variable_get("@#{method}")
        return val if val
        data = send(attribute)
        return nil if data.blank?
        JSON.pretty_generate(data)
      end
      define_method "#{method}=" do |val|
         instance_variable_set("@#{method}", val)
         send("#{attribute}=", nil)
         return if val.blank?
         begin
           send("#{attribute}=", JSON.parse(val))
         rescue
           
         end
       end
       
       define_method valid do
         val = instance_variable_get("@#{method}")
         return if val.blank?
         begin
           JSON.parse(val)
         rescue => ex
           self.errors.add(method.to_sym, ex.message)
         end
       end
       validate valid
    end
  end
  
end

