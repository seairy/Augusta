# -*- encoding : utf-8 -*-
module V1
  module Matches
    module Entities
      # ** DEPRECATED **
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

      class Password < Grape::Entity
        expose :password
        expose :expired_at do |m, o|
          m.password_expired_at.to_i
        end
      end

      # ** DEPRECATED **
      class PracticeMatch < Grape::Entity
        expose :uuid, if: lambda{|m, o| o[:included_uuid]}
        expose :type
        expose :scoring_type do |m, o|
          m.default_player.scoring_type
        end
        expose :scorecards, using: Scorecards do |m, o|
          m.default_player.scorecards
        end
      end

      # ** DEPRECATED **
      class PracticeMatches < Grape::Entity
        expose :uuid
        expose :type
        expose :scoring_type do |m, o|
          m.default_player.scoring_type
        end
        expose :venue, using: Venue
        expose :score do |m, o|
          m.default_player.score
        end
        expose :recorded_scorecards_count do |m, o|
          m.default_player.recorded_scorecards_count
        end
        with_options(format_with: :timestamp){expose :started_at}
      end

      class User < Grape::Entity
        expose :nickname
        expose :portrait do |m, o|
          oss_image(m, :portrait, :w300_h300_fl_q50)
        end
      end

      # ** DEPRECATED **
      class Player < Grape::Entity
        expose :user, using: User
        expose :position
        expose :score
        expose :status
      end

      # ** DEPRECATED **
      class TournamentMatch < Grape::Entity
        expose :uuid, if: lambda{|m, o| o[:included_uuid]}
        expose :type
        expose :player, using: Player do |m, o|
          m.player_by_user(o[:user])
        end
        expose :scorecards, using: Scorecards do |m, o|
          m.player_by_user(o[:user]).scorecards
        end
      end

      # ** DEPRECATED **
      class TournamentMatches < Grape::Entity
        expose :uuid
        expose :type
        expose :venue, using: Venue
        expose :score do |m, o|
          m.player_by_user(o[:user]).score
        end
        expose :recorded_scorecards_count do |m, o|
          m.player_by_user(o[:user]).recorded_scorecards_count
        end
        expose :players_count
        with_options(format_with: :timestamp){expose :started_at}
      end

      class Matches < Grape::Entity
        expose :uuid do |m, o|
          m.match.uuid
        end
        expose :venue do |m, o|
          { name: m.match.venue.name }
        end
        expose :player do |m, o|
          {
            owned: m.owned?,
            scoring_type: m.scoring_type,
            strokes: m.recorded_scorecards_count == 18 ? m.strokes : nil,
            recorded_scorecards_count: m.recorded_scorecards_count
          }
        end
        expose :players_count do |m, o|
          m.match.players_count
        end
        expose :started_at do |m, o|
          m.match.started_at.to_i
        end
      end

      class Match < Grape::Entity
        expose :player do |m, o|
          {
            user: {
              nickname: o[:player].user.nickname,
              portrait: oss_image(o[:player].user, :portrait, :w300_h300_fl_q50)
            },
            scoring_type: o[:player].scoring_type,
            position: o[:player].position,
            recorded_scorecards_count: o[:player].recorded_scorecards_count,
            strokes: o[:player].strokes,
            total: formatted_total(o[:player].total),
            owned: o[:player].owned?
          }
        end
        expose :scorecards do |m, o|
          o[:player].scorecards.map do |scorecard|
            {
              uuid: scorecard.uuid,
              number: scorecard.number,
              par: scorecard.par,
              tee_boxes: scorecard.hole.tee_boxes.map do |tee_box|
                {
                  color: tee_box.color,
                  distance_from_hole: tee_box.distance_from_hole,
                  used: tee_box.color == scorecard.tee_box_color
                }
              end,
              score: scorecard.score,
              putts: scorecard.putts,
              penalties: scorecard.penalties,
              driving_distance: scorecard.driving_distance,
              distance_from_hole: scorecard.distance_from_hole,
              direction: scorecard.direction
            }
          end
        end
      end

      class MatchSummary < Grape::Entity
        expose :venue do |m, o|
          {
            name: m.venue.name,
            courses: m.courses.map do |course|
              {
                uuid: course.uuid,
                name: course.name,
                holes_count: course.holes_count,
                tee_boxes: course.available_tee_boxes
              }
            end
          }
        end
        expose :owner do |m, o|
          {
            nickname: m.owner.nickname,
            portrait: oss_image(m.owner, :portrait, :w300_h300_fl_q50)
          }
        end
        with_options(format_with: :timestamp){expose :started_at}
      end
    end
  end

  class MatchesAPI < Grape::API
    resources :matches do
      desc '历史比赛列表'
      params do
        optional :page, type: String, desc: '页数'
      end
      get :history do
        players = Player.by_user(@current_user).latest.includes(:match).page(params[:page]).per(20)
        present players, with: Matches::Entities::Matches
      end

      desc '比赛信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get :show do
        begin
          match = Match.find_uuid(params[:uuid])
          player = match.player_by_user(@current_user)
          raise PlayerNotFound.new unless player
          present match, with: Matches::Entities::Match, player: player
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PlayerNotFound
          api_error!(20109)
        end
      end

      desc '创建比赛'
      params do
        requires :course_uuids, type: String, desc: '球场标识'
        requires :tee_boxes, type: String, desc: '发球台'
        requires :scoring_type, type: String, values: Player.scoring_types.keys, desc: '记分类型'
      end
      post '/' do
        begin
          courses = params[:course_uuids].split(',').map{|course_uuid| Course.find_uuid(course_uuid)}
          tee_boxes = params[:tee_boxes].split(',')
          match = Match.create_with_player(owner: @current_user, courses: courses, tee_boxes: tee_boxes, scoring_type: params[:scoring_type])
          present uuid: match.uuid
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidGroups
          api_error!(20101)
        end
      end

      desc '获取比赛口令'
      params do
        requires :uuid, type: String, desc: '比赛标识'
      end
      get :password do
        begin
          match = Match.find_uuid(params[:uuid])
          raise PermissionDenied.new unless match.owner.id == @current_user.id
          match.generate_password
          match.reload
          present match, with: Matches::Entities::Password
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidMatchState
          api_error!(20108)
        rescue NotEnoughPassword
          api_error!(20112)
        end
      end

      desc '验证比赛口令'
      params do
        requires :password, type: String, desc: '比赛口令'
      end
      post :verify do
        begin
          match = Match.verify(params[:password])
          raise InvalidMatchState.new if match.finished?
          raise DuplicatedParticipant.new if match.participated?(@current_user)
          present uuid: match.uuid
        rescue InvalidPassword
          api_error!(20113)
        rescue InvalidMatchState
          api_error!(20108)
        rescue DuplicatedParticipant
          api_error!(20107)
        end
      end

      desc '比赛摘要信息'
      params do
        requires :uuid, type: String, desc: '比赛标识'
      end
      get :summary do
        begin
          match = Match.find_uuid(params[:uuid])
          present match, with: Matches::Entities::MatchSummary
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidGroups
          api_error!(20101)
        end
      end

      desc '加入比赛'
      params do
        requires :uuid, type: String, desc: '比赛标识'
        requires :tee_boxes, type: String, desc: '发球台'
        requires :scoring_type, type: String, values: Player.scoring_types.keys, desc: '记分类型'
      end
      post :participate do
        begin
          match = Match.find_uuid(params[:uuid])
          match.participate(user: @current_user, tee_boxes: params[:tee_boxes].split(','), scoring_type: params[:scoring_type])
          present successful_json
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidMatchState
          api_error!(20108)
        rescue DuplicatedParticipant
          api_error!(20107)
        end
      end
    end
  end
end
