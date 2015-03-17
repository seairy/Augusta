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
    end
  end
  
  class VenuesAPI < Grape::API
    resources :venues do
      desc '距离最近的球会列表'
      params do
        requires :latitude, type: String, desc: '纬度'
        requires :longitude, type: String, desc: '经度'
        optional :page, type: String, desc: '页数'
      end
      get :nearest do
        venues = Venue.nearest(params[:latitude], params[:longitude]).page(params[:page]).per(10)
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
        venue = Venue.find_uuid(params[:uuid])
        present venue, with: Venues::Entities::Venue
      end
    end
  end
end
