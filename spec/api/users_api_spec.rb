require 'spec_helper'

describe API do
  include Rack::Test::Methods

  def app
    API
  end

  it 'sign up successful and return uuid' do
    get '/api/v1/matches'
    expect(last_response.status).to eq(200)
    puts JSON.parse(last_response.body)
  end
end