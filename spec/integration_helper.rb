require "spec_helper"

require 'capybara/rspec'
require 'capybara/rails'

Capybara.default_selector = :css
Capybara.default_driver   = :rack_test
Capybara.javascript_driver= :webkit
Capybara.save_and_open_page_path = 'tmp'

def login_as(user, password = "password")
  visit '/'
  fill_in("Email", :with => user.email)
  fill_in("Password", :with => "password")
  click_button("Sign in")
end
