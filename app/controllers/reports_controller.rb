class ReportsController < InheritedResources::Base
  belongs_to :tables, :param => :table_id
  filter_resource_access :nested_in => :tables
  
  def create
    build_resource.user = current_user
    build_resource.formatter = "csv"
    create! { table_report_path(@report.table, @report) }
  end
  
  def update
    update! { table_report_path(@report.table, @report) }
  end
end