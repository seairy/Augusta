class Wechat < ActiveRecord::Base
  self.table_name = 'wechat'

  def expired?
    self.expired_at > Time.now
  end

  class << self
    def access_token
      current_access_token = first
      if current_access_token.nil? or current_access_token.expired?
        request_access_token
      else
        current_access_token
      end
    end

    def request_access_token
      uri = URI.parse("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Setting.key[:wechat][:appid]}&secret=#{Setting.key[:wechat][:secret]}")
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      response = http.request(request)
      json = JSON.parse(response.body)
      first ? first.update!(access_token: json['access_token'], expired_at: Time.now + json['expires_in'].seconds) : create!(access_token: json[:access_token], expired_at: Time.now + json[:expires_in].seconds)
    end
  end
end