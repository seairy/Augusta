# -*- encoding : utf-8 -*-
class Caddie::ScorecardsController < Caddie::BaseController
  def edit
    @scorecard = Scorecard.find(params[:id])
    render @scorecard.player.scoring_type_simple? ? 'edit_simple' : 'edit_professional'
  end

  def update
    begin
      scorecard = Scorecard.find(params[:id])
      if scorecard.player.caddie_id == @current_caddie.id
        if scorecard.player.scoring_type_simple?
          scorecard.update!(scorecard_params)
          scorecard.calculate_player_and_statistic_and_leaderboard!
        else
          if params[:distance_from_hole] and params[:point_of_fall] and params[:penalties] and params[:club]
            strokes = params[:distance_from_hole].each_with_index.map do |distance_from_hole, i|
              { distance_from_hole: distance_from_hole, point_of_fall: params[:point_of_fall][i], penalties: params[:penalties][i], club: params[:club][i] }
            end
            scorecard.update_professional(strokes: strokes)
          end
        end
      end
      render json: AjaxMessenger.new(scorecard.player.id)
    rescue ActiveRecord::RecordNotFound
      render json: AjaxMessenger.new('无效的ID', false)
    rescue HoledStrokeNotFound
      render json: AjaxMessenger.new('没有进洞击球', false)
    rescue DuplicatedHoledStroke
      render json: AjaxMessenger.new('重复的进洞击球', false)
    rescue StandardError => e
      render json: AjaxMessenger.new('网络错误，请重试', false)
    end
  end

  protected
    def scorecard_params
      params.require(:scorecard).permit!
    end
end