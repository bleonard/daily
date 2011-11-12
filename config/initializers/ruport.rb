DSN_CONFIG = YAML.load_file("#{Rails.root}/config/daily.yml")

Ruport::Query.add_source :default,
                         :dsn => "dbi:#{DSN_CONFIG[Rails.env]['adapter']}:database=#{DSN_CONFIG[Rails.env]['database']};host=#{DSN_CONFIG[Rails.env]['host']}", 
                         :user => "#{DSN_CONFIG[Rails.env]['username']}",
                         :password => "#{DSN_CONFIG[Rails.env]['password']}" 
                         