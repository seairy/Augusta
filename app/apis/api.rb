# -*- encoding : utf-8 -*-

module DocFormatter
  def self.call object, env
    object.to_json
  end
end
module ErrorFormatter
  def self.call message, backtrace, options, env
    if message.to_s =~ /\d{5}/
      { error_code: message, message: APIError.message(message) }.to_json
    else
      { error_code: 99999, message: message }.to_json
    end
  end
end

class API < Grape::API
  version :v1
  format :json
  error_formatter :json, ErrorFormatter
  content_type :json, 'application/json; charset=utf8'

  helpers do
    def api_error! code
      error!(code, APIError.send("code_#{code}")[:status])
    end

    def current_user
      @current_user ||= User.authorize!(params[:token])
    end

    def authenticate!
      api_error!(10001) unless current_user
    end
  end

  mount V1::UsersAPI
  namespace do
    before do
      authenticate!
    end
    mount V1::CoursesAPI
    mount V1::MatchesAPI
    mount V1::ScorecardsAPI
  end

  namespace :doc do
    formatter :json, DocFormatter 
    add_swagger_documentation api_version: 'v1'
  end
end
