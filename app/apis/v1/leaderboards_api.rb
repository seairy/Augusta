# -*- encoding : utf-8 -*-
module V1
  module Leaderboards
    module Entities
      class Players < Grape::Entity
        expose :uuid
        expose :position
        expose :user do |m, o|
          {
            nickname: m.user.nickname,
            portrait: oss_image(m.user, :portrait, :w300_h300_fl_q50)
          }
        end
        expose :recorded_scorecards_count
        expose :total do |m, o|
          formatted_total(m.total)
        end
        expose :self do |m, o|
          m.user_id == o[:user].id
        end
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
          leaderboards = match.players.count > 1 ? match.players.ranked : []
          present leaderboards, with: Leaderboards::Entities::Players, user: @current_user
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end
    end
  end
end
