require 'rubygems'
require 'rack/test'
require File.expand_path('../../config/environment', __FILE__)

ENV['RACK_ENV'] ||= 'test'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
end