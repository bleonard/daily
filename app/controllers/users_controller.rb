class UsersController < InheritedResources::Base
  before_filter :user_from_current, :only => :edit
  filter_resource_access
  
  def update
    params[:user][:password] = nil if params[:user][:password].blank?
    
    update! do |success, failure|
      success.all { redirect_after_update }
      failure.all { render :edit }
    end
  end
  
  protected
  def user_from_current
    params[:id] ||= (current_user.try(:id) || 0)
  end
  def redirect_after_update
    sign_in @user, :bypass => true if @user == current_user
    redirect_to user_root_path
  end
end