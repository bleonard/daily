class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user
  
  protected
  
  def set_current_user
    Authorization.current_user = current_user
  end
  
  def permission_denied
    render :file => "public/404.html", :status => 404
  end
end
