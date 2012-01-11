class DailyTablesController < InheritedResources::Base
  filter_resource_access

  def new
    build_resource.metric = "SqlQuery"
    new!
  end
  
  def create
    build_resource.user = current_user
    create!
  end
  
  def update
    update!
  end

  def show
    show! do
      @test_html = @daily_table.test if params[:test]
    end
  end

end