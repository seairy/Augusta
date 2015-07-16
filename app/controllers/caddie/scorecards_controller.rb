# -*- encoding : utf-8 -*-
class Caddie::ScorecardsController < Caddie::BaseController
  def edit
    @scorecard = Scorecard.find(params[:id])
  end

  def update
    @scorecard = Scorecard.find(params[:id])
    if @scorecard.caddie_id == @current_caddie.id
      @scorecard.update!(scorecard_params)
    end
    redirect_to [:caddie, @scorecard.player]
  end

  protected
  def scorecard_params
    params.require(:scorecard).permit!
  end
end
