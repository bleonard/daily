class DailyReportsController < InheritedResources::Base
  nested_belongs_to :daily_table, :optional => true
  filter_resource_access :nested_in => :daily_table, :additional_member => :generate
  
  def create
    build_resource.user = current_user
    create! do |success, failure|
      success.all { redirect_to daily_table_daily_report_path(@daily_report.table, @daily_report)}
      failure.all { render :new }
    end
  end
  
  def update
    update! do |success, failure|
      success.all { redirect_to daily_table_daily_report_path(@daily_report.table, @daily_report)}
      failure.all { render :edit }
    end
  end
  
  def generate
    @daily_report.queue_now!
    redirect_to daily_table_daily_report_path(@daily_report.table, @daily_report)
  end
  
  def destroy
    destroy! { daily_table_path(@daily_report.table) }
  end
  
  def archiveit
    if @daily_report.archive
      flash[:notice] = "Report has been archived."
    else
      flash[:alert] = "Report has not been archived."
    end
    redirect_to daily_table_daily_report_path(@daily_report.table, @daily_report)
  end
  
  def unarchiveit
    if @daily_report.unarchive
      flash[:notice] = "Report has been unarchived."
    else
      flash[:alert] = "Report has not been unarchived."
    end
    redirect_to daily_table_daily_report_path(@daily_report.table, @daily_report)
  end
  
  protected
  
  # methods to make declarative_authorization allow optional table
  def load_daily_table
    @daily_table ||= load_parent_controller_object(:daily_table) if params[:daily_table_id]
    @daily_table  # loaded by inherited_resources if there
  end
  def new_daily_report_for_collection
    @daily_report ||= @daily_table ? new_controller_object_for_collection : DailyReport.new
  end
end