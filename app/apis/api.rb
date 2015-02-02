# -*- encoding : utf-8 -*-
Dir[File.expand_path(File.dirname(__FILE__)) + "/**/*.rb"].each {|f| require f}

module DocFormatter
  def self.call object, env
    object.to_json
  end
end
module ErrorFormatter
  def self.call message, backtrace, options, env
    if message.to_s =~ /\d{5}/
      { error_code: message }.to_json
    else
      { error_code: 00000, data: message }.to_json
    end
  end
end

class API < Grape::API
  version :v1
  format :json
  error_formatter :json, ErrorFormatter
  content_type :json, 'application/json; charset=utf8'

  mount Resources::UsersAPI

  namespace :doc do
    formatter :json, DocFormatter 
    add_swagger_documentation api_version: 'v1'
  end
end