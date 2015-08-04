# -*- encoding : utf-8 -*-
class Caddie::SessionsController < Caddie::BaseController
  skip_before_action :authenticate
  skip_before_action :set_current_caddie
  skip_before_action :sign_up

  def create
    caddie = Caddie.find_or_create(Wechat.find_open_id(params[:code]))
    session[:caddie] = { id: caddie.id, name: caddie.name }
    redirect_to caddie_players_path
  end

  def simulate_sign_in
    if Rails.env == 'development'
      caddie = Caddie.first
      session['caddie'] = { id: caddie.id, name: caddie.name }
      redirect_to caddie_players_path
    else
      redirect_to caddie_oauth2_path
    end
  end
end