# -*- encoding : utf-8 -*-
module V1
  module Strokes
    module Entities
      class Strokes < Grape::Entity
        expose :uuid
        expose :sequence
        expose :distance_from_hole
        expose :point_of_fall
        expose :penalties
        expose :club
      end

      class Scorecard < Grape::Entity
        expose :score
        expose :putts
        expose :penalties
      end

      class StrokeAndScorecard < Grape::Entity
        expose :stroke
        expose :scorecard, using: Scorecard
      end
    end
  end

  class StrokesAPI < Grape::API
    resources :strokes do
      desc '击球记录列表'
      params do
        requires :scorecard_uuid, type: String, desc: '记分卡标识'
      end
      get '/' do
        begin
          scorecard = Scorecard.find_uuid(params[:scorecard_uuid])
          raise PermissionDenied.new unless scorecard.player.user_id == @current_user.id
          raise InvalidScoringType.new if scorecard.player.scoring_type_simple?
          present scorecard.strokes, with: Strokes::Entities::Strokes
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20103)
        end
      end
    end
  end
end