# -*- encoding : utf-8 -*-
module V1
  module Entities
    class Groups < Grape::Entity
      expose :uuid
      expose :name
      expose :holes_count
      expose :tee_boxes do |m, o|
        [:red, :white, :blue, :black, :gold]
      end
    end

    class Course < Grape::Entity
      expose :name
      expose :groups, using: Groups
    end

    class Courses < Grape::Entity
      expose :uuid
      expose :name
      expose :address
      expose :distance, if: lambda{|m, o| o[:latitude] and o[:longitude]} do |m, o|
        m.distance_to([o[:latitude], o[:longitude]]).round(2)
      end
    end

    class Provinces < Grape::Entity
      expose :name
      expose :courses, using: Courses
    end
  end
  
  class CoursesAPI < Grape::API
    resources :courses do
      desc '距离最近的球场列表'
      params do
        requires :latitude, type: String, desc: '纬度'
        requires :longitude, type: String, desc: '经度'
        optional :page, type: String, desc: '页数'
      end
      get :nearest do
        courses = Course.nearest(params[:latitude], params[:longitude]).page(params[:page]).per(10)
        present courses, with: Entities::Courses, latitude: params[:latitude], longitude: params[:longitude]
      end

      desc '按省份划分的球场列表'
      get :sectionalized_by_province do
        present Province.alphabetic.includes(:courses), with: Entities::Provinces
      end

      desc '球场信息'
      params do
        requires :uuid, type: String, desc: '球场标识'
      end
      get :show do
        course = Course.find_uuid(params[:uuid])
        present course, with: Entities::Course
      end
    end
  end
end
