# -*- encoding : utf-8 -*-
module JSONFormatter
  def self.call object, env
    if object.class == Hash and object.has_key?(:code)
      { code: object[:code], data: nil }.to_json
    else
      { code: 10000, data: object }.to_json
    end
  end
end
module DocFormatter
  def self.call object, env
    object.to_json
  end
end
module ErrorFormatter
  def self.call message, backtrace, options, env
    if message.to_s =~ /\d{5}/
      { code: message, data: nil }.to_json
    else
      { code: 20006, data: message }.to_json
    end
  end
end

class BaseAPI < Grape::API
  version 'v1'
  prefix :api
  format :json
  formatter :json, JSONFormatter
  error_formatter :json, ErrorFormatter
  content_type :json, 'application/json; charset=utf8'

  mount V1API::User

  namespace :doc do
    formatter :json, DocFormatter 
    add_swagger_documentation api_version: 'v1'
  end
end