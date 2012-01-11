module DailyConfig
  extend self
  
  def set_root(root)
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
  
  def database_config
    env_hash['database']
  end
  
  def database_init
    db = database_config
    return if db.empty?
    Ruport::Query.add_source :default,
                             :dsn => "dbi:#{db['adapter'].camelize}:database=#{db['database']};host=#{db['host']}", 
                             :user => "#{db['username']}",
                             :password => "#{db['password']}"
                             
    require File.expand_path('../activemetric', __FILE__)
    ActiveMetric::Base.establish_connection db
  end
  
  def config_init(config)
    if !subdirectory.blank?
      config.assets.prefix = "/#{subdirectory}/assets"
    end
  end
  
  def load_classes
    Dir[Rails.root.join("app/transforms/*")].each { |f| require_dependency f }
    Dir[Rails.root.join("app/formatters/*")].each { |f| require_dependency f }
    Dir[Rails.root.join("app/metrics/*")].each    { |f| require_dependency f }

    if defined? Daily::Engine
      Dir[Daily::Engine.root.join("app/transforms/*")].each { |f| require_dependency f }
      Dir[Daily::Engine.root.join("app/formatters/*")].each { |f| require_dependency f }
      Dir[Daily::Engine.root.join("app/metrics/*")].each    { |f| require_dependency f }
    end
  end
  
end