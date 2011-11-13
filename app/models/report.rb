class Report < ActiveRecord::Base
  include SharedBehaviors
  belongs_to :user
  belongs_to :table
  
  generate_guid :filename
  
  validates_presence_of :user
  validates_presence_of :table
  validates_stripped_presence_of :name
  validates_stripped_presence_of :formatter

  def guid_append
    return "" if formatter.blank?
    ".#{formatter.strip}"
  end

  protected


end