DailyConfig.database_init

Dir[Rails.root.join("app/formatters/*")].each { |f| require f }
Dir[Rails.root.join("app/transforms/*")].each { |f| require f }
                         