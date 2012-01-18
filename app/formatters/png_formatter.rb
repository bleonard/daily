module Ruport
  class Formatter::Png < Formatter
    renders :png, :for => [Ruport::Controller::Table]
    
    CHART_TYPES = %w{line line_xy scatter bar venn pie pie_3d sparkline meter}
    
    save_as_binary_file
    
    def google_hash
      out = options.to_hash.symbolize_keys
      columns = out.delete(:columns) || data.column_names

      if out[:legend] == false or skip_legend?
        out.delete(:legend)
      else
        out[:legend] ||= columns
      end
      
      unless out[:data]
        out[:data] = []
        columns.each_with_index do |col, i|
          out[:data][i] ||= []
        end
        data.each_with_index do |row, i|
          columns.each_with_index do |col, i|
            out[:data][i] << row[col]
          end
        end
      end
      
      out
    end
    
    def skip_legend?
      google_type == "sparkline"
    end
    
    def google_type
      options.chart_type.try(:to_s).try(:downcase) || CHART_TYPES.first
    end
    
    def google_url
      url = Gchart.send(google_type, google_hash)
      unwise = %w({ } | \ ^ [ ] `)
      unwise.each { |c| url.gsub!(c, "%#{c[0].to_s(16).upcase}") }
      url.gsub!(/\s/, "%20")
      url
    end
    
    def finalize_table
      require 'open-uri'
      output << open(google_url).read
    end
    
  end
end
