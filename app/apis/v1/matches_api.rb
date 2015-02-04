# -*- encoding : utf-8 -*-
module V1
  module Entities
    class Match < Grape::Entity
      expose :uuid
      expose :scorecards
    end
  end

  class MatchesAPI < Grape::API
    resources :matches do
      desc '历史赛事列表'
      params do
        optional :page, type: String, desc: '页数'
      end
      get '/' do
        courses = ::Match.by_user(@current_user).per(10)
        present courses, with: Entities::Courses, latitude: params[:latitude], longitude: params[:longitude]
      end

      desc '创建练习赛事'
      params do
        requires :group_uuids, type: String, desc: '子场标识'
        requires :start_from, type: String, desc: '发球洞'
        requires :tee_box, type: String, values: ['red', 'white', 'blue', 'black', 'gold'], desc: '发球台'
      end
      post :practice do
        begin
          groups = params[:group_uuids].split(',').map{|group_uuid| Group.find_uuid(group_uuid)}
          match = ::Match.create_practice!(owner: @current_user, groups: groups, start_from: params[:start_from], tee_box: params[:tee_box])
          present match, with: Entities::Match
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        end
      end
    end
  end
end
