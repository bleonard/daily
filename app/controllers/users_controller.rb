class UsersController < InheritedResources::Base
  before_filter :user_from_current, :only => :edit
  filter_resource_access
  
  def update
    update! do |success, failure|
      success.all { redirect_to user_root_path }
      failure.all { render :edit }
    end
  end
  
  protected
  def user_from_current
    params[:id] ||= current_user.id
  end
end