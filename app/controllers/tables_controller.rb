class TablesController < InheritedResources::Base
  filter_resource_access

  def create
    build_resource.user = current_user
    build_resource.data_type = "sql"
    create! { table_path(@table) }
  end
  
  def update
    update! { table_path(@table) }
  end

end