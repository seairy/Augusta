# -*- encoding : utf-8 -*-
class Caddie::SessionsController < Caddie::BaseController
  skip_before_action :authenticate

  def oauth2
    redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Setting.key[:wechat][:appid]}&redirect_uri=http%3A%2F%2Filovegolfclub.com%2Fcaddie%2Fsignin_with_open_id&response_type=code&scope=snsapi_base&state=caddiesignin#wechat_redirect"
  end

  def create_with_open_id
    open_id = Wechat.request_open_id(params[:code])
    caddie = Caddie.find_or_create(open_id)
    session[:caddie] = { id: caddie.id, name: caddie.name }
    redirect_to caddie_players_path
  end

  def simulate
    if Rails.env == 'development'
      caddie = Caddie.first
      session[:caddie] = { id: caddie.id, name: caddie.name }
      redirect_to caddie_players_path
    else
      redirect_to caddie_oauth2_path
    end
  end
end
