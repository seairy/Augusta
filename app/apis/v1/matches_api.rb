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
            scoring_type: m.scoring_type,
            total: m.total,
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
            position: o[:player].position,
            recorded_scorecards_count: o[:player].recorded_scorecards_count,
            strokes: o[:player].strokes,
            total: o[:player].total
          }
        end
        expose :scoring_type do |m, o|
          o[:player].scoring_type
        end
        expose :scorecards, using: Scorecards do |m, o|
          o[:player].scorecards
        end
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
        players = Player.by_user(@current_user).latest.includes(:match).includes(:scorecards).page(params[:page]).per(20)
        present players, with: Matches::Entities::Matches
      end

      desc '比赛信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get :show do
        begin
          match = Match.find_uuid(params[:uuid])
          player = match.players.by_user(@current_user).first
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
          match = Match.create_practice(owner: @current_user, courses: courses, tee_boxes: tee_boxes, scoring_type: params[:scoring_type])
          present uuid: match.uuid
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidGroups
          api_error!(20101)
        end
      end

      # ** DEPRECATED **
      desc '练习赛事信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get '/practice/show' do
        begin
          match = @current_user.matches.type_practices.find_uuid(params[:uuid])
          present match, with: Matches::Entities::PracticeMatch
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end

      # ** DEPRECATED **
      desc '创建练习赛事'
      params do
        requires :course_uuids, type: String, desc: '球场标识'
        requires :tee_boxes, type: String, desc: '发球台'
        requires :scoring_type, type: String, values: Player.scoring_types.keys, desc: '记分类型'
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

      # ** DEPRECATED **
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

      # ** DEPRECATED **
      desc '竞技赛事信息'
      params do
        requires :uuid, type: String, desc: '赛事标识'
      end
      get '/tournament/show' do
        begin
          match = Match.type_tournaments.find_uuid(params[:uuid])
          raise PlayerNotFound.new unless match.participated?(@current_user) 
          present match, with: Matches::Entities::TournamentMatch, user: @current_user
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PlayerNotFound
          api_error!(20109)
        end
      end

      # ** DEPRECATED **
      desc '创建竞技赛事'
      params do
        requires :name, type: String, desc: '名称'
        requires :password, type: Integer, desc: '密码'
        requires :rule, type: String, values: Match.rules.keys, desc: '规则'
        requires :course_uuids, type: String, desc: '球场标识'
        requires :tee_boxes, type: String, desc: '发球台'
        optional :remark, type: String, desc: '备注'
      end
      post :tournament do
        begin
          courses = params[:course_uuids].split(',').map{|course_uuid| Course.find_uuid(course_uuid)}
          tee_boxes = params[:tee_boxes].split(',')
          match = Match.create_tournament(owner: @current_user, courses: courses, tee_boxes: tee_boxes, rule: params[:rule], name: params[:name], password: params[:password], remark: params[:remark])
          present uuid: match.uuid
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidGroups
          api_error!(20101)
        end
      end

      # ** DEPRECATED **
      desc '加入竞技赛事'
      params do
        requires :uuid, type: String, desc: '赛事标识'
        requires :password, type: Integer, desc: '密码'
        requires :tee_boxes, type: String, desc: '发球台'
      end
      post 'tournament/participate' do
        begin
          Match.type_tournaments.find_uuid(params[:uuid]).participate(user: @current_user, password: params[:password].to_s, tee_boxes: params[:tee_boxes].split(','))
          present successful_json
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue InvalidMatchType
          api_error!(20105)
        rescue InvalidPassword
          api_error!(20106)
        rescue DuplicatedParticipant
          api_error!(20107)
        rescue InvalidState
          api_error!(20108)
        end
      end

      # ** DEPRECATED **
      desc '历史练习赛事列表'
      params do
        optional :scoring_type, type: String, values: Player.scoring_types.keys, default: 'simple', desc: '记分类型'
        optional :page, type: String, desc: '页数'
      end
      get :practice do
        matches = Match.type_practices.by_owner(@current_user).joins(:players).where(players: { scoring_type_cd: params[:scoring_type]}).includes(:venue).includes(:players).page(params[:page]).per(10)
        present matches, with: Matches::Entities::PracticeMatches
      end

      # ** DEPRECATED **
      desc '历史竞技赛事列表'
      params do
        optional :page, type: String, desc: '页数'
      end
      get :tournament do
        matches = Match.type_tournaments.participated(@current_user).includes(:venue).includes(:players).page(params[:page]).per(10)
        present matches, with: Matches::Entities::TournamentMatches, user: @current_user
      end
    end
  end
end
