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

  def archiveit
    if @daily_table.archive
      flash[:notice] = "Table has been archived."
    else
      flash[:alert] = "Table has not been archived."
    end
    redirect_to @daily_table
  end
  
  def unarchiveit
    if @daily_table.unarchive
      flash[:notice] = "Table has been unarchived."
    else
      flash[:alert] = "Table has not been unarchived."
    end
    redirect_to @daily_table
  end

  def destroy
    destroy! { user_root_path }
  end

end