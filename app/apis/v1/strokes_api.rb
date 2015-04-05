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
          present scorecard.strokes.sorted, with: Strokes::Entities::Strokes
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20103)
        end
      end

      desc '创建击球记录'
      params do
        requires :scorecard_uuid, type: String, desc: '记分卡标识'
        requires :distance_from_hole, type: Integer, desc: '距离球洞码数'
        optional :point_of_fall, type: String, values: Stroke.point_of_falls.keys, desc: '球的落点'
        optional :penalties, type: Integer, desc: '罚杆数'
        requires :club, type: String, values: Stroke.clubs.keys, desc: '球杆'
      end
      post '/' do
        begin
          scorecard = Scorecard.find_uuid(params[:scorecard_uuid])
          raise PermissionDenied.new unless scorecard.player.user_id == @current_user.id
          raise InvalidScoringType.new if scorecard.player.scoring_type_simple?
          stroke = scorecard.strokes.create!(distance_from_hole: params[:distance_from_hole], point_of_fall: params[:point_of_fall], penalties: params[:penalties], club: params[:club])
          entity = { stroke: { uuid: stroke.uuid}, scorecard: scorecard }
          present entity, with: Strokes::Entities::StrokeAndScorecard
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20103)
        end
      end

      desc '编辑击球记录'
      params do
        requires :uuid, type: String, desc: '击球记录标识'
        requires :distance_from_hole, type: Integer, desc: '距离球洞码数'
        optional :point_of_fall, type: String, values: Stroke.point_of_falls.keys, desc: '球的落点'
        optional :penalties, type: Integer, desc: '罚杆数'
        requires :club, type: String, values: Stroke.clubs.keys, desc: '球杆'
      end
      put '/' do
        begin
          stroke = Stroke.find_uuid(params[:uuid])
          raise PermissionDenied.new unless stroke.scorecard.player.user_id == @current_user.id
          raise InvalidScoringType.new if stroke.scorecard.player.scoring_type_simple?
          stroke.update!(distance_from_hole: params[:distance_from_hole], point_of_fall: params[:point_of_fall], penalties: params[:penalties], club: params[:club])
          present stroke.scorecard, with: Strokes::Entities::Scorecard
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20103)
        end
      end

      desc '删除击球记录'
      params do
        requires :uuid, type: String, desc: '击球纪录标识'
      end
      delete '/' do
        begin
          stroke = Stroke.find_uuid(params[:uuid])
          raise PermissionDenied.new unless stroke.scorecard.player.user_id == @current_user.id
          raise InvalidScoringType.new if stroke.scorecard.player.scoring_type_simple?
          stroke.destroy!
          present stroke.scorecard, with: Strokes::Entities::Scorecard
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
