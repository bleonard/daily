class TablesController < InheritedResources::Base
  filter_resource_access

  def create
    build_resource.user = current_user
    build_resource.data_type = "sql"
    create!
  end
  
  def update
    update!
  end

end