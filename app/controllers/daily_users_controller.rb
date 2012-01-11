class DailyUsersController < InheritedResources::Base
  before_filter :user_from_current, :only => :edit
  filter_resource_access
  
  def update
    params[:daily_user][:password] = nil if params[:daily_user][:password].blank?
    
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
    if @daily_user == current_user
      sign_in @daily_user, :bypass => true
      redirect_to user_root_path
    elsif permitted_to? :show, @daily_user
      redirect_to daily_user_path(@daily_user)
    else
      redirect_to user_root_path
    end
  end
end