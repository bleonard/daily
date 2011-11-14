module DailyConfig
  extend self
  
  def hash
    @hash ||= (YAML.load_file("#{Rails.root}/config/daily.yml") || {})
  end
  
  def env_hash
    @env_hash ||= (hash[Rails.env] || {})
  end
  
  def database_init
    db = env_hash['database']
    return if db.empty?
    Ruport::Query.add_source :default,
                             :dsn => "dbi:#{db['adapter']}:database=#{db['database']};host=#{db['host']}", 
                             :user => "#{db['username']}",
                             :password => "#{db['password']}"
  end
end