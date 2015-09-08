# -*- encoding : utf-8 -*-
class Caddie::BaseController < ApplicationController
  layout 'caddie'

  skip_before_action :verify_authenticity_token
  before_action :authenticate, except: %w{verify}
  before_action :set_current_caddie, except: %w{verify}
  before_action :sign_up, except: %w{verify}

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
          qr_scene_id = begin
            notification['EventKey'] ? notification['EventKey'].scan(/^(qrscene_)?(\d{6})$/)[0][1].to_i : -1
          rescue
            -1
          end
          case notification['Event']
          when 'SCAN'
            case qr_scene_id
            when Wechat::Scene[:invite_caddie][:id]
              Caddie.scoring_for_player(open_id: notification['FromUserName'], ticket: notification['Ticket'])
            end
          when 'subscribe'
            case qr_scene_id
            when Wechat::Scene[:invite_caddie][:id]
              Caddie.scoring_for_player(open_id: notification['FromUserName'], ticket: notification['Ticket'])
            end
          end
        when 'voice'
          
        when 'video'
          
        when 'shortvideo'
          
        else
          raise ArgumentError, 'Unknown Weixin Message'
        end
      end
      render text: (params[:echostr] || 'success')
    else
      render text: 'failure'
    end
  end

  protected
    def authenticate
      redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Setting.key[:wechat][:appid]}&redirect_uri=http%3A%2F%2Filovegolfclub.com%2Fcaddie%2Fsign_in&response_type=code&scope=snsapi_base&state=caddiesignin#wechat_redirect" unless session['caddie']
    end

    def set_current_caddie
      @current_caddie = Caddie.find(session['caddie']['id'])
    end

    def sign_up
      redirect_to caddie_sign_up_form_path if @current_caddie.unactivated?
    end
end