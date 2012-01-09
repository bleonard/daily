$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "daily/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "daily"
  s.version     = Daily::VERSION
  s.authors     = ["Brian Leonard"]
  s.email       = ["brian@bleonard.com"]
  s.homepage    = "https://github.com/bleonard/daily"
  s.summary     = "Reporting application"
  s.description = "Reporting application"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.mdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
