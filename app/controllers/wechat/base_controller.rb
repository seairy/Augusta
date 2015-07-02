# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false

  def verify
    if params[:signature] and params[:timestamp] and params[:nonce] and Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join) == params[:signature]
      if request.post?
        notification = MultiXml.parse(request.raw_post)['xml']
        case notification['MsgType']
        when 'text'
          
        when 'image'
          
        when 'location'
          
        when 'link'
          
        when 'event'
          puts "****** #{notification}"
        when 'voice'
          
        when 'video'
          
        when 'shortvideo'
          
        else
          raise ArgumentError, 'Unknown Weixin Message'
        end
      end
      render text: params[:echostr]
    else
      render text: 'failure'
    end
  end
end