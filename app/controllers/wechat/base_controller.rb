# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def verify
    if params[:signature] and params[:timestamp] and params[:nonce] and Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join) == params[:signature]
      if request.get?
        render text: params[:echostr]
      elsif request.post?
        hash = MultiXml.parse(request.raw_post)
        puts "****** hash: [#{hash}]"
      end
    else
      render text: 'failure'
    end
  end
end