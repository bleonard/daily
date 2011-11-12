class TablesController < InheritedResources::Base
  filter_resource_access

  def create
    build_resource.user = current_user
    build_resource.data_type = "sql"
    create!{ user_root_url }
  end
  
  def update
    update!{ user_root_url }
  end

end