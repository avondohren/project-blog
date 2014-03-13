ENV['RACK_ENV'] = 'test'

require_relative '../app/main'

require 'capybara/rspec'
Capybara.app = Sample