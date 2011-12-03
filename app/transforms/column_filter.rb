class ColumnFilter < Transform
  def result
    to_remove = table.column_names - columns
    table.remove_columns(to_remove)
    table
  end
end