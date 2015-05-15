# -*- encoding : utf-8 -*-
module V1
  module Players
    module Entities
      class Players < Grape::Entity
        expose :uuid
        expose :user do |m, o|
          {
            nickname: m.user.nickname,
            portrait: oss_image(m.user, :portrait, :w300_h300_fl_q50)
          }
        end
        expose :position
        expose :recorded_scorecards_count
        expose :strokes
        expose :total
        expose :scorecards do |m, o|
          m.statistic.scorecards
        end
      end
    end
  end
  
  class PlayersAPI < Grape::API
    resources :players do
      desc '参赛者信息'
      params do
        requires :uuid, type: String, desc: '参赛者标识'
      end
      get :show do
        begin
          player = Player.find_uuid(params[:uuid])
          raise PlayerNotFound.new unless player.match.player_by_user(@current_user)
          present player, with: Players::Entities::Players
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PlayerNotFound
          api_error!(20109)
        end
      end
    end
  end
end