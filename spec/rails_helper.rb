# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'rspec'
require 'simplecov'
require 'simplecov_json_formatter'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::HTMLFormatter
])

SimpleCov.start do
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Specs', 'spec'

  add_filter 'ActionView'
end

Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }
# spec/rails_helper.rb
Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
