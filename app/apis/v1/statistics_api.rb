# -*- encoding : utf-8 -*-
module V1
  module Entities
    class Scorecard < Grape::Entity

    end
  end

  class StatisticsAPI < Grape::API
    resources :scorecards do
      desc '修改记分卡'
      params do
        requires :uuid, type: String, desc: '记分卡标识'
        requires :score, type: Integer, desc: '杆数'
        requires :putts, type: Integer, desc: '推杆数'
        requires :penalties, type: Integer, desc: '罚杆数'
        requires :driving_distance, type: Integer, desc: '开球距离'
        requires :direction, type: Integer, desc: '开球方向'
      end
      put '/' do
        begin
          scorecard = Scorecard.find_uuid(params[:uuid])
          raise PermissionDenied.new unless scorecard.match.owner_id == @current_user.id
          present nil
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        end
      end
    end
  end
end
