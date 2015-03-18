# -*- encoding : utf-8 -*-
module V1
  module Matches
    module Entities
      class Venue < Grape::Entity
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

      class PracticeMatch < Grape::Entity
        expose :uuid, if: lambda{|m, o| o[:included_uuid]}
        expose :type
        expose :scoring_type do |m, o|
          m.default_player.scoring_type
        end
        expose :scorecards, using: Scorecards do |m, o|
          m.players.first.scorecards
        end
      end

      class PracticeMatches < Grape::Entity
        expose :uuid
        expose :type
        expose :scoring_type do |m, o|
          m.default_player.scoring_type
        end
        expose :venue, using: Venue
        expose :score
        expose :recorded_scorecards_count
        expose :started_at do |m, o|
          m.started_at.to_i
        end
      end
    end
  end

  class MatchesAPI < Grape::API
    resources :matches do
      desc '历史练习赛事列表'
      params do
        optional :page, type: String, desc: '页数'
      end
      get :practice do
        matches = Match.by_owner(@current_user).includes(:venue).includes(:scorecards).page(params[:page]).per(10)
        present matches, with: Matches::Entities::PracticeMatches, latitude: params[:latitude], longitude: params[:longitude]
      end

      desc '练习赛事信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get '/practice/show' do
        begin
          match = @current_user.matches.find_uuid(params[:uuid])
          present match, with: Matches::Entities::PracticeMatch
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end

      desc '创建练习赛事'
      params do
        requires :course_uuids, type: String, desc: '球场标识'
        requires :tee_boxes, type: String, desc: '发球台'
        requires :scoring_type, type: String, values: ['simple', 'professional'], desc: '记分类型'
      end
      post :practice do
        begin
          courses = params[:course_uuids].split(',').map{|course_uuid| Course.find_uuid(course_uuid)}
          tee_boxes = params[:tee_boxes].split(',')
          match = Match.create_practice(owner: @current_user, courses: courses, tee_boxes: tee_boxes, scoring_type: params[:scoring_type])
          present match, with: Matches::Entities::PracticeMatch, included_uuid: true
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidGroups
          api_error!(20101)
        end
      end

      desc '删除练习赛事'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      delete :practice do
        begin
          match = @current_user.matches.find_uuid(params[:uuid])
          match.trash
          present successful_json
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end
    end
  end
end
