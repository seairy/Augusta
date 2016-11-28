# -*- encoding : utf-8 -*-
class Caddie::PlayersController < Caddie::BaseController
  def index
    @players = @current_caddie.players.order(created_at: :desc).page(params[:page])
    render 'index_more', layout: false unless @players.first_page?
  end

  def show
    @player = @current_caddie.players.find(params[:id])
  end
end
