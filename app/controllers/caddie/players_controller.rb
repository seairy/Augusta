# -*- encoding : utf-8 -*-
class Caddie::PlayersController < Caddie::BaseController
  def index
    @players = @current_caddie.players.latest
  end

  def show
    @player = @current_caddie.players.find(params[:id])
  end
end
