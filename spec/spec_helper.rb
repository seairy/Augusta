require File.expand_path('../../config/environment', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.include Rack::Test::Methods
  config.raise_errors_for_deprecations!
  config.color = true
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end

def authenticate
  @current_user = User.last
end