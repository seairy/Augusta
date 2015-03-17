require 'spec_helper'

describe 'CoursesAPI' do
  include Rack::Test::Methods

  def app
    API
  end

  before do
    authenticate
  end

  it '获得距离最近的球场列表' do
    get '/v1/courses/nearest', token: @current_user.available_token, page: 2, latitude: 39, longitude: 116
    expect(last_response.status).to eq(200)
    courses = JSON.parse(last_response.body)
    expect(courses.count).to eq(10)
  end

  it '获得按省份划分的球场列表' do
    get '/v1/courses/sectionalized_by_province', token: @current_user.available_token
    expect(last_response.status).to eq(200)
    provinces = JSON.parse(last_response.body)
    expect(provinces.count).to be >= 20
  end

  it '获得球场信息' do
    get '/v1/courses/show', token: @current_user.available_token, uuid: Course.all.sample.uuid
    expect(last_response.status).to eq(200)
    course = JSON.parse(last_response.body)
  end
end