require 'spec_helper'

describe 'UsersAPI' do
  include Rack::Test::Methods

  def app
    API
  end

  it '用户简单注册并返回基本信息' do
    post '/v1/users/sign_up_simple'
    expect(last_response.status).to eq(201)
    user = JSON.parse(last_response.body)
    expect(user['uuid']).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    expect(user['type']).to eq('guest')
    expect(user['nickname']).to match(/^游客\d{6}/)
    expect(user['token']).to match(/^\S{22}$/)
  end
end