class DailyUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :tables, :class_name => "DailyTable", :foreign_key => "user_id"
  has_many :reports, :class_name => "DailyReport", :foreign_key => "user_id"
  
  def role_symbols
    return [] if new_record?
    
    out = [:user]
    out << :admin if admin?
    out
  end
end
