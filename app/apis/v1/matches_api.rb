# -*- encoding : utf-8 -*-
module V1
  module Matches
    module Entities
      class Course < Grape::Entity
        expose :uuid
        expose :name
      end

      class Scorecards < Grape::Entity
        expose :uuid
        expose :number
        expose :par
        expose :strokes
        expose :putting
        expose :penalty
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
        expose :course, using: Course
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
        courses = ::Match.by_owner(@current_user).page(params[:page]).per(10)
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
        requires :tee_box, type: String, values: ['red', 'white', 'blue', 'black', 'gold'], desc: '发球台'
      end
      post :practice do
        begin
          groups = params[:group_uuids].split(',').map{|group_uuid| Group.find_uuid(group_uuid)}
          match = ::Match.create_practice(owner: @current_user, groups: groups, tee_box: params[:tee_box])
          present match, with: Matches::Entities::Match, included_uuid: true
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end

      desc '统计信息'
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
