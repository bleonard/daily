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

  s.add_dependency 'rails', "~> 3.1.1"
  s.add_dependency 'json'
  s.add_dependency 'jquery-rails'
  
  s.add_dependency 'devise'
  s.add_dependency 'declarative_authorization'
  s.add_dependency 'inherited_resources'
  s.add_dependency 'simple_form'
  
  s.add_dependency 'delayed_job'
  
  s.add_dependency 'ruport'
  s.add_dependency 'ruport-util'

  s.add_dependency 'dbi'
  s.add_dependency 'dbd-mysql'
  
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
  
  require 'rubygems'
  require 'rails/all'
  require 'json'
  require 'jquery-rails'
  
  require 'devise'
  require 'declarative_authorization'
  require 'inherited_resources'
  require 'simple_form'
  
  require 'delayed_job'
  
  require 'ruport'
  require 'ruport/util'
  
  require 'dbi'
  require 'dbd/mysql'
end
