DailyConfig.database_init

Dir[Rails.root.join("app/formatters/*")].each { |f| require_dependency f }
Dir[Rails.root.join("app/transforms/*")].each { |f| require_dependency f }
                         