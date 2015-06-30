# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def verify
    if params[:signature] and params[:echostr] and params[:timestamp] and params[:nonce] and Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join) == params[:signature]
      puts "*** return: #{params[:echostr]}"
      render text: params[:echostr]
    else
      puts "******* params[:signature]: #{params[:signature]}"
      puts "******* params[:echostr]: #{params[:echostr]}"
      puts "******* params[:timestamp]: #{params[:timestamp]}"
      puts "******* params[:nonce]: #{params[:nonce]}"
      puts "******* params.sort.join: #{[params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join}"
      puts "******* sha1: #{Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join)}"
      puts "*** return: failure"
      render text: 'failure'
    end
  end
end