# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def verify
    puts "********* #{request.raw_post}"
    puts "********* #{request.body}"
    if params[:signature] and params[:timestamp] and params[:nonce] and Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join) == params[:signature]
      render text: params[:echostr]
    else
      render text: 'failure'
    end
  end
end