# -*- encoding : utf-8 -*-
module V1
  module Leaderboards
    module Entities
      class Leaderboards < Grape::Entity
        expose :position
        expose :user do |m, o|
          {
            nickname: m.user.nickname,
            portrait: oss_image(m.user, :portrait, :w300_h300_fl_q50)
          }
        end
        expose :recorded_scorecards_count
        expose :total
      end
    end
  end
  
  class LeaderboardsAPI < Grape::API
    resources :leaderboards do
      desc '排行榜'
      params do
        requires :match_uuid, type: String, desc: '比赛标识'
      end
      get '/' do
        begin
          match = Match.find_uuid(params[:match_uuid])
          leaderboards = match.players.count > 1 ? match.players : []
          present leaderboards, with: Leaderboards::Entities::Leaderboards
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end
    end
  end
end
