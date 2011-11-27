DailyConfig.database_init

Dir[Rails.root.join("app/formatters/*")].each { |f| require f }
                         