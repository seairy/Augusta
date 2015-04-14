# -*- encoding : utf-8 -*-
module V1
  module Statistics
    module Entities
      class SimpleStatistic < Grape::Entity
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
        private
          def scorecards
            scorecards = object.player.scorecards
            { par: [scorecards.out.sorted.map(&:par), object.player.out_par, scorecards.in.sorted.map(&:par), object.player.in_par, object.player.par].flatten,
              score: [scorecards.out.sorted.map(&:score), object.player.out_score, scorecards.in.sorted.map(&:score), object.player.in_score, object.player.score].flatten,
              status: formatted_scorecards_status([scorecards.out.sorted.map(&:status), object.player.out_status, scorecards.in.sorted.map(&:status), object.player.in_status, object.player.status].flatten) }
          end
      end

      class ProfessionalStatistic < Grape::Entity
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
            score_par_3: m.score_par_3,
            score_par_4: m.score_par_4,
            score_par_5: m.score_par_5,
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
            distance_3_5_from_hole_in_green: m.distance_3_5_from_hole_in_green
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
            shots_within_100ft: m.shots_within_100ft,
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
            gir_to_within_15ft: m.gir_to_within_15ft,
            gir_to_within_15ft_percentage: m.gir_to_within_15ft_percentage,
            holes_of_gir_to_within_15ft: m.holes_of_gir_to_within_15ft
          }
        end
        expose :item_07 do |m, o|
          {
            drive_fairways_hit: m.drive_fairways_hit,
            drive_left_roughs_hit: m.drive_left_roughs_hit,
            drive_right_roughs_hit: m.drive_right_roughs_hit,
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
            club_1w: m.club_1w,
            club_3w: m.club_3w,
            club_5w: m.club_5w,
            club_7w: m.club_7w
          }
        end
        private
          def scorecards
            scorecards = object.player.scorecards
            { par: [scorecards.out.sorted.map(&:par), object.player.out_par, scorecards.in.sorted.map(&:par), object.player.in_par, object.player.par].flatten,
              score: [scorecards.out.sorted.map(&:score), object.player.out_score, scorecards.in.sorted.map(&:score), object.player.in_score, object.player.score].flatten,
              status: formatted_scorecards_status([scorecards.out.sorted.map(&:status), object.player.out_status, scorecards.in.sorted.map(&:status), object.player.in_status, object.player.status].flatten) }
          end
      end
    end
  end

  class StatisticsAPI < Grape::API
    resources :matches do
      desc '练习赛事简单记分统计'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get '/practice/statistics/simple' do
        begin
          match = Match.find_uuid(params[:match_uuid])
          raise PermissionDenied.new unless match.owner_id == @current_user.id
          raise InvalidScoringType.new unless match.default_player.scoring_type_simple?
          match.default_player.statistic.calculate!
          present match.default_player.statistic, with: Statistics::Entities::SimpleStatistic
        rescue ActiveRecord::RecordNotFound
          api_error!(10002)
        rescue PermissionDenied
          api_error!(10003)
        rescue InvalidScoringType
          api_error!(20104)
        end
      end

      desc '练习赛事专业记分统计'
      params do
        requires :match_uuid, type: String, desc: '赛事标识'
      end
      get '/practice/statistics/professional' do
        begin
          match = Match.find_uuid(params[:match_uuid])
          raise PermissionDenied.new unless match.owner_id == @current_user.id
          raise InvalidScoringType.new unless match.default_player.scoring_type_professional?
          match.default_player.statistic.calculate!
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
  end
end
