class ReportsController < InheritedResources::Base
  nested_belongs_to :table
  filter_resource_access :nested_in => :tables, :additional_member => :generate
  
  def create
    build_resource.user = current_user
    create!
  end
  
  def update
    update!
  end
  
  def generate
    @report.queue_now!
    redirect_to table_report_path(@report.table, @report)
  end
end