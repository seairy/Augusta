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
        expose :total do |m, o|
          formatted_total(m.total)
        end
        expose :scorecards do |m, o|
          m.statistic.scorecards
        end
      end

      class QRUrl < Grape::Entity
        expose :url do |m, o|
          m
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

      desc '邀请球僮记分'
      params do
        requires :match_uuid, type: String, desc: '比赛标识'
      end
      put :invite_caddie do
        begin
          match = Match.find_uuid(params[:match_uuid])
          player = match.players.by_user(@current_user).first
          raise PermissionDenied.new unless player
          present player.invite_caddie, with: Players::Entities::QRUrl
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidMatchState
          api_error!(20108)
        rescue AlreadyInvited
          api_error!(20117)
        rescue InvalidResponse
          api_error!(10007)
        end
      end
    end
  end
end
