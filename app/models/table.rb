class Table < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :data
  validates_presence_of :data_type
  validate :data_type_known
  
  def sql?
    data_type == "sql"
  end
  
  protected
  def data_type_known
    return if data_type.blank?
    unless sql?
      errors.add(:data_type, "is not known")
    end
  end
  
end