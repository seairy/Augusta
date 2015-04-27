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

      class VisitedVenues < Grape::Entity
        expose :uuid
        expose :name
        expose :address
        expose :visited_count
      end

      class Venues < Grape::Entity
        expose :uuid
        expose :name
        expose :address
        expose :distance, if: lambda{|m, o| o[:latitude] and o[:longitude]} do |m, o|
          m.distance_to([o[:latitude], o[:longitude]]).round(2)
        end
      end

      class Provinces < Grape::Entity
        expose :name
        expose :venues, using: Venues
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
    resources :venues do
      desc '距离最近的球会列表'
      params do
        requires :latitude, type: String, desc: '纬度'
        requires :longitude, type: String, desc: '经度'
      end
      get :nearest do
        venues = Venue.nearest(params[:latitude], params[:longitude])
        present venues, with: Venues::Entities::Venues, latitude: params[:latitude], longitude: params[:longitude]
      end

      desc '按省份划分的球会列表'
      get :sectionalized_by_province do
        present Province.alphabetic.includes(:venues), with: Venues::Entities::Provinces
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

      desc '已访问球场列表'
      get :visited do
        venues = @current_user.visited_venues
        present venues, with: Venues::Entities::VisitedVenues
      end

      desc '竞技赛列表'
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
