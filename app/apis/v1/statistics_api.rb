# -*- encoding : utf-8 -*-
module V1
  module Statistics
    module Entities
      class SimpleStatistic < Grape::Entity
        expose :match do |m, o|
          { venue: { name: m.player.match.venue.name }, played_at: m.player.match.created_at.to_i }
        end
        expose :scorecards
        expose :score
        expose :net
        expose :putts
        expose :penalties
        expose :longest_drive_length
        expose :average_drive_length
        expose :drive_fairways_hit
        expose :scrambles
        expose :bounce
        expose :advantage_transformation
        expose :gir
        expose :putts_per_gir
        expose :score_par_3
        expose :score_par_4
        expose :score_par_5
        expose :double_eagle
        expose :eagle
        expose :birdie
        expose :par
        expose :bogey
        expose :double_bogey
      end

      class ProfessionalStatistic < Grape::Entity
        expose :match do |m, o|
          { venue: { name: m.player.match.venue.name }, played_at: m.player.match.created_at.to_i }
        end
        expose :scorecards
        expose :item_01 do |m, o|
          {
            score: m.score,
            net: m.net,
            putts: m.putts,
            penalties: m.penalties,
            front_6_score: m.front_6_score,
            middle_6_score: m.middle_6_score,
            last_6_score: m.last_6_score,
            wasted_shots_from_drives: m.wasted_shots_from_drives
          }
        end
        expose :item_02 do |m, o|
          {
            average_score_par_3: m.average_score_par_3,
            average_score_par_4: m.average_score_par_4,
            average_score_par_5: m.average_score_par_5,
            scrambles: m.scrambles,
            scrambles_percentage: m.scrambles_percentage,
            non_gir: m.non_gir
          }
        end
        expose :item_03 do |m, o|
          {
            average_putts: m.average_putts,
            putts_per_gir: m.putts_per_gir,
            putts_per_non_gir: m.putts_per_non_gir,
            first_putt_length: m.first_putt_length,
            first_putt_length_gir: m.first_putt_length_gir,
            first_putt_length_non_gir: m.first_putt_length_non_gir,
            holed_putt_length: m.holed_putt_length,
            distance_0_1_from_hole_in_green: m.distance_0_1_from_hole_in_green,
            distance_1_2_from_hole_in_green: m.distance_1_2_from_hole_in_green,
            distance_2_3_from_hole_in_green: m.distance_2_3_from_hole_in_green,
            distance_3_5_from_hole_in_green: m.distance_3_5_from_hole_in_green,
            distance_5_8_from_hole_in_green: m.distance_5_8_from_hole_in_green,
            distance_8_13_from_hole_in_green: m.distance_8_13_from_hole_in_green,
            distance_13_33_from_hole_in_green: m.distance_13_33_from_hole_in_green,
          }
        end
        expose :item_04 do |m, o|
          {
            sand_saves: m.sand_saves,
            bunker_shots: m.bunker_shots,
            sand_saves_percentage: m.sand_saves_percentage,
            distance_0_10_from_hole_in_bunker: m.distance_0_10_from_hole_in_bunker,
            distance_10_20_from_hole_in_bunker: m.distance_10_20_from_hole_in_bunker,
            distance_20_50_from_hole_in_bunker: m.distance_20_50_from_hole_in_bunker,
            distance_50_100_from_hole_in_bunker: m.distance_50_100_from_hole_in_bunker
          }
        end
        expose :item_05 do |m, o|
          {
            up_and_downs: m.up_and_downs,
            up_and_downs_count: m.up_and_downs_count,
            up_and_downs_percentage: m.up_and_downs_percentage,
            shots_within_100: m.shots_within_100,
            chip_ins: m.chip_ins,
            longest_chip_ins_length: m.longest_chip_ins_length
          }
        end
        expose :item_06 do |m, o|
          {
            gir: m.gir,
            non_gir: m.non_gir,
            gir_percentage: m.gir_percentage,
            non_gir_percentage: m.non_gir_percentage,
            holes_of_gir: m.holes_of_gir,
            gir_to_within_5: m.gir_to_within_5,
            gir_to_within_5_percentage: m.gir_to_within_5_percentage,
            holes_of_gir_to_within_5: m.holes_of_gir_to_within_5
          }
        end
        expose :item_07 do |m, o|
          {
            drive_fairways_hit: m.drive_fairways_hit,
            drive_left_roughs_hit: m.drive_left_roughs_hit,
            drive_right_roughs_hit: m.drive_right_roughs_hit,
            drive_fairways_count: m.drive_fairways_count,
            drive_left_roughs_count: m.drive_left_roughs_count,
            drive_right_roughs_count: m.drive_right_roughs_count,
            holes_of_drive_fairways: m.holes_of_drive_fairways,
            holes_of_drive_left_roughs: m.holes_of_drive_left_roughs,
            holes_of_drive_right_roughs: m.holes_of_drive_right_roughs
          }
        end
        expose :item_08 do |m, o|
          {
            longest_drive_length: m.longest_drive_length,
            longest_2_drive_length: m.longest_2_drive_length,
            average_drive_length: m.average_drive_length,
            good_drives: m.good_drives,
            good_drives_percentage: m.good_drives_percentage,
            holes_of_good_drives: m.holes_of_good_drives
          }
        end
        expose :item_09 do |m, o|
          {
            double_eagle: m.double_eagle,
            double_eagle_percentage: m.double_eagle_percentage,
            eagle: m.eagle,
            eagle_percentage: m.eagle_percentage,
            birdie: m.birdie,
            birdie_percentage: m.birdie_percentage,
            par: m.par,
            par_percentage: m.par_percentage,
            bogey: m.bogey,
            bogey_percentage: m.bogey_percentage,
            double_bogey: m.double_bogey,
            double_bogey_percentage: m.double_bogey_percentage,
            advantage_transformation: m.advantage_transformation,
            bounce: m.bounce
          }
        end
        expose :item_10 do |m, o|
          {
            frequently_used_clubs: m.frequently_used_clubs,
            clubs: m.clubs
          }
        end
      end

      class CustomizedStatistic < Grape::Entity
        expose :finished_count
        expose :score_par_3
        expose :score_par_4
        expose :score_par_5
        expose :score
        expose :handicap
        expose :putts
        expose :gir
        expose :putts_per_gir
        expose :average_drive_length
        expose :drive_fairways_hit
        expose :advantage_transformation
        expose :bounce
        expose :double_eagle
        expose :eagle
        expose :birdie
        expose :par
        expose :bogey
        expose :double_bogey
      end
    end
  end

  class StatisticsAPI < Grape::API
    resources :statistics do
      desc '简单记分统计'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get :simple do
        begin
          match = Match.find_uuid(params[:match_uuid])
          player = match.player_by_user(@current_user)
          raise PlayerNotFound.new unless player
          raise InvalidScoringType.new unless player.scoring_type_simple?
          present player.statistic, with: Statistics::Entities::SimpleStatistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PlayerNotFound
          api_error!(20109)
        rescue InvalidScoringType
          api_error!(20104)
        end
      end
    end

    resources :statistics do
      desc '专业记分统计'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get :professional do
        begin
          match = Match.find_uuid(params[:match_uuid])
          player = match.player_by_user(@current_user)
          raise PlayerNotFound.new unless player
          raise InvalidScoringType.new unless player.scoring_type_professional?
          present player.statistic, with: Statistics::Entities::ProfessionalStatistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PlayerNotFound
          api_error!(20109)
        rescue InvalidScoringType
          api_error!(20104)
        end
      end
    end

    resources :matches do
      # ** DEPRECATED **
      desc '练习赛事简单记分统计（作废）'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get '/practice/statistics/simple' do
        begin
          match = Match.find_uuid(params[:match_uuid])
          raise PermissionDenied.new unless match.owner_id == @current_user.id
          raise InvalidScoringType.new unless match.default_player.scoring_type_simple?
          present match.default_player.statistic, with: Statistics::Entities::SimpleStatistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20104)
        end
      end

      # ** DEPRECATED **
      desc '练习赛事专业记分统计（作废）'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get '/practice/statistics/professional' do
        begin
          match = Match.find_uuid(params[:match_uuid])
          raise PermissionDenied.new unless match.owner_id == @current_user.id
          raise InvalidScoringType.new unless match.default_player.scoring_type_professional?
          present match.default_player.statistic, with: Statistics::Entities::ProfessionalStatistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20104)
        end
      end
    end

    resources :statistics do
      desc '统计'
      get '/' do
        players = @current_user.players.select{|player| player.match and player.finished?}
        scorecards = players.map(&:scorecards).flatten
        entity = {
          rank: '1,000,000+',
          handicap: 0,
          best_score: players.map(&:score).min,
          average_score: players.count.zero? ? nil : (players.map(&:score).reduce(:+) / players.count).round(2),
          finished_matches_count: players.count,
          total_matches_count: @current_user.players.count
        }.merge(Hash[[:double_eagle, :eagle, :birdie, :par, :bogey, :double_bogey].map do |name|
          ["#{name}", scorecards.count.zero? ? nil : (scorecards.select{|scorecard| scorecard.send("#{name}?")}.count.to_f / scorecards.count).round(2),]
        end])
        present entity
      end

      desc '个性化统计'
      params do
        optional :matches_count, type: String, values: ['5', '10', '30', '50', '100', 'all'], desc: '赛事数量'
        optional :date_begin, type: Integer, desc: '开始日期'
        optional :date_end, type: Integer, desc: '结束日期'
        optional :venue_uuid, type: String, desc: '球会标识'
      end
      post :customize do
        begin
          customized_statistic = nil
          if params[:matches_count]
            customized_statistic = CustomizedStatistic.new(:by_match, @current_user, matches_count: params[:matches_count])
          elsif params[:date_begin] and params[:date_end]
            customized_statistic = CustomizedStatistic.new(:by_date, @current_user, date_begin: params[:date_begin], date_end: params[:date_end])
          elsif params[:venue_uuid]
            customized_statistic = CustomizedStatistic.new(:by_venue, @current_user, venue_uuid: params[:venue_uuid])
          else
            raise ArgumentError.new
          end
          present customized_statistic, with: Statistics::Entities::CustomizedStatistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue ArgumentError
          api_error!(20201)
        end
      end
    end
  end
end
