# -*- encoding : utf-8 -*-
module V1
  module Venues
    module Entities
      class Courses < Grape::Entity
        expose :uuid
        expose :name
        expose :holes_count
        expose :tee_boxes do |m, o|
          [:red, :white, :blue, :black, :gold]
        end
      end

      class Venue < Grape::Entity
        expose :name
        expose :courses, using: Courses
      end

      class PlayedVenues < Grape::Entity
        expose :uuid
        expose :name
        expose :address
        expose :played_count
      end

      class VisitedVenues < Grape::Entity
        expose :uuid
        expose :name
        expose :address
        expose :visited_count
      end

      class Venues < Grape::Entity
        expose :uuid
        expose :name
        # deprecated
        expose :address
        expose :holes_count do |m, o|
          o[:courses][m.id]
        end
        expose :distance, if: lambda{|m, o| o[:latitude] and o[:longitude]} do |m, o|
          m.distance_to([o[:latitude], o[:longitude]]).round(2)
        end
      end

      class Provinces < Grape::Entity
        expose :name
        expose :venues, using: Venues
      end

      class User < Grape::Entity
        expose :nickname
        expose :portrait do |m, o|
          oss_image(m, :portrait, :w300_h300_fl_q50)
        end
      end

      class TournamentMatches < Grape::Entity
        expose :uuid
        expose :user, using: User do |m, o|
          m.owner
        end
        expose :name
        expose :rule
        expose :password
        expose :players_count
        expose :remark
        expose :courses, using: Courses
        with_options(format_with: :timestamp){expose :started_at}
      end
    end
  end
  
  class VenuesAPI < Grape::API
    helpers do
      def preload_courses_by_venues venues
        Course.where(venue_id: venues.map(&:id)).inject(Hash.new(0)){|result, course| result[course.venue_id] += course.holes_count; result}
      end
    end

    resources :venues do
      desc '附近的球会列表'
      params do
        requires :latitude, type: String, desc: '纬度'
        requires :longitude, type: String, desc: '经度'
        optional :page, type: Integer, desc: '页数'
      end
      get :nearby do
        venues = Venue.nearest(params[:latitude], params[:longitude]).page(params[:page]).per(20)
        courses = preload_courses_by_venues(venues)
        present venues, with: Venues::Entities::Venues, latitude: params[:latitude], longitude: params[:longitude], courses: courses
      end

      desc '最近的球会信息'
      params do
        requires :latitude, type: String, desc: '纬度'
        requires :longitude, type: String, desc: '经度'
        optional :page, type: Integer, desc: '页数'
      end
      get :nearest do
        venue = Venue.nearest(params[:latitude], params[:longitude]).first
        present venue, with: Venues::Entities::Venue
      end

      desc '按省份划分的球会列表'
      get :sectionalized_by_province do
        provinces = Province.alphabetic
        courses = preload_courses_by_venues(provinces.map(&:venues).flatten)
        present provinces, with: Venues::Entities::Provinces, courses: courses
      end

      desc '球会信息'
      params do
        requires :uuid, type: String, desc: '球会标识'
      end
      get :show do
        begin
          venue = Venue.find_uuid(params[:uuid])
          present venue, with: Venues::Entities::Venue
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end

      desc '比赛球会列表'
      get :visited do
        venues = @current_user.played_venues
        present venues, with: Venues::Entities::PlayedVenues
      end

      # ** DEPRECATED **
      desc '已访问球场列表（作废）'
      get :visited do
        venues = @current_user.visited_venues
        present venues, with: Venues::Entities::VisitedVenues
      end

      # ** DEPRECATED **
      desc '竞技赛列表（作废）'
      params do
        requires :uuid, type: String, desc: '球会标识'
      end
      get 'matches/tournament' do
        begin
          matches = Venue.find_uuid(params[:uuid]).matches.type_tournaments.latest
          present matches, with: Venues::Entities::TournamentMatches
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end
    end
  end
end
