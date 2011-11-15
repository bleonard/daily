class ReportsController < InheritedResources::Base
  nested_belongs_to :table, :optional => true
  filter_resource_access :nested_in => :table, :additional_member => :generate
  
  def create
    build_resource.user = current_user
    create! do |success, failure|
      success.all { redirect_to table_report_path(@report.table, @report)}
      failure.all { render :new }
    end
  end
  
  def update
    update! do |success, failure|
      success.all { redirect_to table_report_path(@report.table, @report)}
      failure.all { render :edit }
    end
  end
  
  def generate
    @report.queue_now!
    redirect_to table_report_path(@report.table, @report)
  end
  
  protected
  
  # methods to make declarative_authorization allow optional table
  def load_table
    @table ||= load_parent_controller_object(:table) if params[:table_id]
    @table  # loaded by inherited_resources if there
  end
  def new_report_for_collection
    @report ||= @table ? new_controller_object_for_collection : Report.new
  end
end