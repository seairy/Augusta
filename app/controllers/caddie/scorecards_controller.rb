# -*- encoding : utf-8 -*-
class Caddie::ScorecardsController < Caddie::BaseController
  def edit
    @scorecard = Scorecard.find(params[:id])
    render @scorecard.player.scoring_type_simple? ? 'edit_simple' : 'edit_professional'
  end

  def update
    @scorecard = Scorecard.find(params[:id])
    if @scorecard.player.caddie_id == @current_caddie.id
      if @scorecard.player.scoring_type_simple?
        @scorecard.update!(scorecard_params)
      else
        assaf
      end
    end
    redirect_to [:caddie, @scorecard.player]
  end

  protected
    def scorecard_params
      params.require(:scorecard).permit!
    end
end