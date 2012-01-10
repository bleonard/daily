module DailyConfig
  extend self
  
  def set_root(root)
    puts "here it is.........."
    puts root
    @root = root
  end
  def set_env(env)
    @env = env
  end
  
  def rails_root
    return @root if @root
    Rails.root
  end
  
  def rails_env
    return @env if @env
    Rails.env
  end
  
  def hash
    @hash ||= (YAML.load_file("#{rails_root}/config/daily.yml") || {})
  end
  
  def env_hash
    @env_hash ||= (hash[rails_env] || {})
  end
  
  def subdirectory
    return "" if rails_env == "test"
    hash['subdirectory'] || env_hash['subdirectory'] || ""
  end
  
  def database_init
    db = env_hash['database']
    return if db.empty?
    Ruport::Query.add_source :default,
                             :dsn => "dbi:#{db['adapter'].camelize}:database=#{db['database']};host=#{db['host']}", 
                             :user => "#{db['username']}",
                             :password => "#{db['password']}"
  end
  
  def config_init(config)
    if !subdirectory.blank?
      config.assets.prefix = "/#{subdirectory}/assets"
    end
  end
  
end