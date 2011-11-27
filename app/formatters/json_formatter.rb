module Ruport
  class Formatter::JSON < Formatter
    renders :json, :for => [ Ruport::Controller::Row, Ruport::Controller::Table,
                             Ruport::Controller::Group, Ruport::Controller::Grouping ]

    # Hook for setting available options using a template. See the template 
    # documentation for the available options and their format.
    def apply_template
      apply_table_format_template(template.table)
      apply_grouping_format_template(template.grouping)
    end

    # Start the JSON
    #
    def build_table_header
      output << "[\n"
    end
  
    # Uses the Row controller to build up the table body.
    #
    def build_table_body
      data.each_with_index do |row, i|
        output << ",\n" if i > 0 
        build_row(row)
      end
      output << "\n"
    end

    # End the JSON
    def build_table_footer
      output << "]"
    end

    # Renders individual rows for the table.
    #
    def build_row(data = self.data)
      values = data.to_a
      keys = self.data.column_names.to_a
      hash = {}
      values.each_with_index do |val, i|
        key = (keys[i] || i).to_s
        hash[key] = val
      end
      line = hash.to_json.to_s
      output << "  #{line}"
    end

    # Renders the header for a group using the group name.
    #
    def build_group_header
      output << "  \"#{data.name}\":"
    end

    # Creates the group body. Since group data is a table, just uses the
    # Table controller.
    #
    def build_group_body
      render_table data, options.to_hash
    end

    # Generates the body for a grouping. Iterates through the groups and
    # renders them using the group controller.
    #
    def build_grouping_body
      arr = []
      data.each do |_,group|                     
        arr << render_group(group, options)
      end
      output << arr.join(",\n")
    end

    private

    def apply_table_format_template(t)
    end
  
    def apply_grouping_format_template(t)
    end

  end
end
