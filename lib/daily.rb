require "daily/engine"
require "daily/daily_config"
require "daily/shared_behaviors"
require "daily/has_data"

Authorization::AUTH_DSL_FILES = [Pathname.new(Daily::Engine.root || '').join("config", "authorization_rules.rb").to_s]

module Daily
end
