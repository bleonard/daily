class MovingAverage < Transform
  def self.form_keys
    [:columns, :days, :date]
  end
  
  def num_days
    val = setting(:days).to_i
    val <= 0 ? 7 : val
  end
  
  def date_column
    setting(:date) || default_date_column || first_date_column
  end
  
  def result  
    cols = self.columns
    datecol = self.date_column
    daycount = self.num_days
    
    avg_cols = cols.collect { |col| "#{col}_#{daycount}" }
    
    out = Ruport::Data::Table.new( :column_names => [datecol] + cols + avg_cols)
    
    data = day_data
    days = data["days"]
    first = data["earliest"]
    latest = data["latest"]
    
    current = first
    while current <= latest do
      row = {}
      row[datecol] = current
      
      cols.each do |col|
        # this cols value for the day
        value = 0
        value = days[current][col].to_f if days[current]
          
        # add them up
        sum = 0
        count = 0
        check = current - daycount + 1
        while check <= current
          count += 1 unless check < first
          sum += days[check][col].to_f if days[check]
          check += 1
        end  
        
        row["#{col}_#{daycount}"] = sum / count
        row["#{col}"] = value
      end
      
      out << row
      current += 1
    end
    
    out
  end
  
  protected
  
  def self.to_day(time_or_date)
    time = Time.zone.parse(time_or_date.strftime("%Y-%m-%d %H:%M:%S %z"))
    Date.new(time.year, time.month, time.day)
  end

  def day_data
    earliest = Date.new(2032,1,1)
    latest = Date.new(1492,1,1)
    datenum = column_name_hash[date_column]
    cols = self.columns
    
    days = {}
    
    table.each do |row|
      time = row[datenum]
      day = self.class.to_day(time)
      latest = day if day > latest
      earliest = day if day < earliest
      
      days[day] ||= {}
      cols.each do |col|
        index = column_name_hash[col]
        if index
          days[day][col] ||= 0
          days[day][col] += row[index].to_f
        end
      end
    end
    
    {"days" => days, "earliest" => earliest, "latest" => latest}
  end
  
  def column_name_hash
    return @column_name_hash if @column_name_hash
    @column_name_hash = {}
    table.column_names.each_with_index do |name, i|
      @column_name_hash[name.to_s] = i
    end
    @column_name_hash
  end
  
  def default_date_column
    ["created_at", "updated_at", "state_changed_at"].each do |col|
      return col if column_name_hash[col]
    end
    return nil
  end
  
  def first_date_column
    return nil if table.size == 0
    table[0].each_with_index do |val, i|
      if val.is_a? Date or val.is_a? Time
        return table.column_names[i]
      end
    end
    nil
  end
end