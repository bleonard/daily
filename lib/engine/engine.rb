module Daily
  class Engine < Rails::Engine
    
    # Load rake tasks
    rake_tasks do
      load File.expand_path('../../tasks/user.rake', __FILE__)
    end
    
  end
end
