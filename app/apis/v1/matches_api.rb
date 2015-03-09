# -*- encoding : utf-8 -*-
module V1
  module Matches
    module Entities
      class Course < Grape::Entity
        expose :uuid
        expose :name
        expose :address
      end

      class Scorecards < Grape::Entity
        expose :uuid
        expose :number
        expose :par
        expose :tee_box_color
        expose :distance_from_hole_to_tee_box
        expose :score
        expose :putts
        expose :penalties
        expose :driving_distance
        expose :direction
      end

      class Match < Grape::Entity
        expose :uuid, if: lambda{|m, o| o[:included_uuid]}
        expose :type
        expose :scorecards, using: Scorecards
      end

      class Matches < Grape::Entity
        expose :uuid
        expose :type
        expose :course, using: Course
        expose :score
        expose :recorded_scorecards_count
        expose :started_at
      end
    end
  end

  class MatchesAPI < Grape::API
    resources :matches do
      desc '历史赛事列表'
      params do
        optional :page, type: String, desc: '页数'
      end
      get '/' do
        courses = ::Match.by_owner(@current_user).includes(:course).includes(:scorecards).page(params[:page]).per(10)
        present courses, with: Matches::Entities::Matches, latitude: params[:latitude], longitude: params[:longitude]
      end

      desc '赛事信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get :show do
        begin
          match = @current_user.matches.find_uuid(params[:uuid])
          present match, with: Matches::Entities::Match
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end

      desc '创建练习赛事'
      params do
        requires :group_uuids, type: String, desc: '子场标识'
        requires :tee_boxes, type: String, desc: '发球台'
      end
      post :practice do
        begin
          groups = params[:group_uuids].split(',').map{|group_uuid| Group.find_uuid(group_uuid)}
          tee_boxes = params[:tee_boxes].split(',')
          match = Match.create_practice(owner: @current_user, groups: groups, tee_boxes: tee_boxes)
          present match, with: Matches::Entities::Match, included_uuid: true
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidGroups
          api_error!(20101)
        end
      end

      desc '赛事统计信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get :statistics do
        begin
          match = @current_user.matches.find_uuid(params[:uuid])
          present ''
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end
    end
  end
end
