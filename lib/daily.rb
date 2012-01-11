require 'rubygems'
require 'rails/all'
require 'json'
require 'jquery-rails'

require 'devise'
require 'declarative_authorization'
require 'inherited_resources'
require 'simple_form'

require 'delayed_job'
require 'delayed_job_active_record'

require 'ruport'
require 'ruport/util'

require 'dbi'
require 'dbd/mysql'

require "daily/activemetric"

require "daily/daily_config"
require "daily/shared_behaviors"
require "daily/has_data"

require "engine/engine"

Authorization::AUTH_DSL_FILES = [Pathname.new(Daily::Engine.root || '').join("config", "authorization_rules.rb").to_s]
