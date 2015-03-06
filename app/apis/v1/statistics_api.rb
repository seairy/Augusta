# -*- encoding : utf-8 -*-
module V1
  module Statistics
    module Entities
      class Statistic < Grape::Entity
        expose :scorecards
        expose :score
        expose :net
        expose :putts
        expose :penalties
        private
          def scorecards
            scorecards = object.match.scorecards
            { par: [scorecards.out.sorted.map(&:par), object.match.out_par, scorecards.in.sorted.map(&:par), object.match.in_par, object.match.par].flatten,
              score: [scorecards.out.sorted.map(&:score), object.match.out_score, scorecards.in.sorted.map(&:score), object.match.in_score, object.match.score].flatten,
              status: [scorecards.out.sorted.map(&:status), object.match.out_status, scorecards.in.sorted.map(&:status), object.match.in_status, object.match.status].flatten }
          end
      end
    end
  end

  class StatisticsAPI < Grape::API
    resources :statistics do
      desc '数据统计'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get :show do
        begin
          match = Match.find_uuid(params[:match_uuid])
          raise PermissionDenied.new unless match.owner_id == @current_user.id
          present match.statistic, with: Statistics::Entities::Statistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        end
      end
    end
  end
end
