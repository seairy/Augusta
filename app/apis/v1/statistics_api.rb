# -*- encoding : utf-8 -*-
module V1
  module Statistics
    module Entities
      class Statistic < Grape::Entity
        expose :scorecards
        expose :score
        expose :net
        expose :putts
        expose :penalties
        expose :longest_drive_length
        expose :average_drive_length
        expose :drive_fairways_hit
        expose :scrambles
        expose :bounce
        expose :advantage_transformation
        expose :greens_in_regulation
        expose :putts_per_gir
        expose :score_par_3
        expose :score_par_4
        expose :score_par_5
        expose :double_eagle
        expose :eagle
        expose :birdie
        expose :par
        expose :bogey
        expose :double_bogey
        private
          def scorecards
            scorecards = object.player.scorecards
            { par: [scorecards.out.sorted.map(&:par), object.player.out_par, scorecards.in.sorted.map(&:par), object.player.in_par, object.player.par].flatten,
              score: [scorecards.out.sorted.map(&:score), object.player.out_score, scorecards.in.sorted.map(&:score), object.player.in_score, object.player.score].flatten,
              status: formatted_scorecards_status([scorecards.out.sorted.map(&:status), object.player.out_status, scorecards.in.sorted.map(&:status), object.player.in_status, object.player.status].flatten) }
          end
      end
    end
  end

  class StatisticsAPI < Grape::API
    resources :matches do
      desc '练习赛事简单记分统计'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get '/practice/statistics/simple' do
        begin
          match = Match.find_uuid(params[:match_uuid])
          raise PermissionDenied.new unless match.owner_id == @current_user.id
          match.default_player.statistic.calculate!
          present match.default_player.statistic, with: Statistics::Entities::Statistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        end
      end
    end
  end
end
