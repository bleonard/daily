DSN_CONFIG = YAML.load_file("#{Rails.root}/config/daily.yml")

if DSN_CONFIG
  # not used in test for example
  Ruport::Query.add_source :default,
                         :dsn => "dbi:#{DSN_CONFIG[Rails.env]['adapter']}:database=#{DSN_CONFIG[Rails.env]['database']};host=#{DSN_CONFIG[Rails.env]['host']}", 
                         :user => "#{DSN_CONFIG[Rails.env]['username']}",
                         :password => "#{DSN_CONFIG[Rails.env]['password']}"
end
                         
# monkey patching HTML formatter to be safe

module Ruport
  class Formatter::HTML < Formatter    
    
    def safe(val)
      ERB::Util.html_escape(val.to_s)
    end
    
    def safe_join(array, sep)
      safe_array = array.collect{ |a| safe(a) }
      safe_array.join(sep)
    end

    # Generates table headers based on the column names of your Data::Table.  
    #
    # This method does not do anything if options.show_table_headers is false
    # or the Data::Table has no column names.
    def build_table_header
      output << "\t<table>\n"
      unless data.column_names.empty? || !options.show_table_headers
        output << "\t\t<tr>\n\t\t\t<th>" + 
          safe_join(data.column_names, "</th>\n\t\t\t<th>") + 
          "</th>\n\t\t</tr>\n"
      end
    end
    
    # Renders individual rows for the table.
    def build_row(data = self.data)
      output <<
        "\t\t<tr>\n\t\t\t<td>" +
        safe_join(data.to_a, "</td>\n\t\t\t<td>") +
        "</td>\n\t\t</tr>\n"
    end

    # Renders the header for a group using the group name.
    #
    def build_group_header
      output << "\t<p>#{safe(data.name)}</p>\n"
    end
    
    private
    
    def render_justified_grouping
      output << "\t<table>\n\t\t<tr>\n\t\t\t<th>" +
        "#{safe(data.grouped_by)}</th>\n\t\t\t<th>" +
        safe_join(grouping_columns, "</th>\n\t\t\t<th>") + 
        "</th>\n\t\t</tr>\n"
      data.each do |name, group|                     
        group.each_with_index do |row, i|
          output << "\t\t<tr>\n\t\t\t"
          if i == 0
            output << "<td class=\"groupName\">#{safe(name)}</td>\n\t\t\t<td>"
          else
            output << "<td>&nbsp;</td>\n\t\t\t<td>"
          end
          output << safe_join(row.to_a, "</td>\n\t\t\t<td>") +
            "</td>\n\t\t</tr>\n"
        end
      end
      output << "\t</table>\n"
    end
  end
end

                         