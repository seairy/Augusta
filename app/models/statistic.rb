class Statistic < ActiveRecord::Base
  belongs_to :player
  attr_accessor :double_eagle_percentage
  attr_accessor :eagle_percentage
  attr_accessor :birdie_percentage
  attr_accessor :par_percentage
  attr_accessor :bogey_percentage
  attr_accessor :double_bogey_percentage
  attr_accessor :front_6_score
  attr_accessor :middle_6_score
  attr_accessor :last_6_score
  attr_accessor :wasted_shots_from_drives
  attr_accessor :longest_drive_length
  attr_accessor :longest_2_drive_length
  attr_accessor :average_drive_length
  attr_accessor :drive_fairways_hit
  attr_accessor :drive_left_roughs_hit
  attr_accessor :drive_right_roughs_hit
  attr_accessor :drive_fairways_count
  attr_accessor :drive_left_roughs_count
  attr_accessor :drive_right_roughs_count
  attr_accessor :holes_of_drive_fairways
  attr_accessor :holes_of_drive_left_roughs
  attr_accessor :holes_of_drive_right_roughs
  attr_accessor :scrambles
  attr_accessor :scrambles_percentage
  attr_accessor :bounce
  attr_accessor :advantage_transformation
  attr_accessor :gir
  attr_accessor :non_gir
  attr_accessor :gir_percentage
  attr_accessor :non_gir_percentage
  attr_accessor :average_putts
  attr_accessor :putts_per_gir
  attr_accessor :putts_per_non_gir
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length_gir
  attr_accessor :first_putt_length_non_gir
  attr_accessor :holed_putt_length
  attr_accessor :distance_0_1_from_hole_in_green
  attr_accessor :distance_1_2_from_hole_in_green
  attr_accessor :distance_2_3_from_hole_in_green
  attr_accessor :distance_3_5_from_hole_in_green
  attr_accessor :sand_saves
  attr_accessor :bunker_shots
  attr_accessor :sand_saves_percentage
  attr_accessor :distance_0_10_from_hole_in_bunker
  attr_accessor :distance_10_20_from_hole_in_bunker
  attr_accessor :distance_20_50_from_hole_in_bunker
  attr_accessor :distance_50_100_from_hole_in_bunker
  attr_accessor :up_and_downs
  attr_accessor :up_and_downs_count
  attr_accessor :shots_within_100ft
  attr_accessor :up_and_downs_percentage
  attr_accessor :chip_ins
  attr_accessor :longest_chip_ins_length
  attr_accessor :holes_of_gir
  attr_accessor :gir_to_within_15ft
  attr_accessor :gir_to_within_15ft_percentage
  attr_accessor :holes_of_gir_to_within_15ft
  attr_accessor :good_drives
  attr_accessor :good_drives_percentage
  attr_accessor :holes_of_good_drives
  attr_accessor :club_1w
  attr_accessor :club_3w
  attr_accessor :club_5w
  attr_accessor :club_7w
  attr_accessor :club_2h
  attr_accessor :club_3h
  attr_accessor :club_4h
  attr_accessor :club_5h
  attr_accessor :club_1i
  attr_accessor :club_2i
  attr_accessor :club_3i
  attr_accessor :club_4i
  attr_accessor :club_5i
  attr_accessor :club_6i
  attr_accessor :club_7i
  attr_accessor :club_8i
  attr_accessor :club_9i
  attr_accessor :club_pw
  attr_accessor :club_gw
  attr_accessor :club_sw
  attr_accessor :club_lw
  attr_accessor :club_pt
  after_initialize :setup_after_initialize

  def setup_after_initialize
    scorecards = player.scorecards.finished
    if scorecards.any?
      par_4_and_5_scorecards = scorecards.select{|scorecard| scorecard.par > 3}
      gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts - scorecard.penalties) <= (scorecard.par - 2)}
      non_gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts - scorecard.penalties) > (scorecard.par - 2)}
      @average_drive_length = (par_4_and_5_scorecards.map(&:driving_distance).reduce(:+).to_f / par_4_and_5_scorecards.count).round(2)
      @scrambles = non_gir_scorecards.select{|scorecard| scorecard.score <= scorecard.par}.count
      @scrambles_percentage = "#{((non_gir_scorecards.select{|scorecard| scorecard.score <= scorecard.par}.count.to_f / non_gir_scorecards.count) * 100).round(2)}%"
      @bounce = "#{((scorecards.inject(previous: nil, bounce: 0) do |result, scorecard|
        if scorecard.score - scorecard.par >= 1
          result[:previous] = 'bogey+'
        elsif scorecard.par - scorecard.score >= 1
          result[:bounce] += 1 if result[:previous] == 'bogey+'
          result[:previous] = 'birdie+'
        else
          result[:previous] = 'par'
        end
        result
      end[:bounce].to_f / 9) * 100).round(2)}%"
      @advantage_transformation = gir_scorecards.select{|scorecard| scorecard.par - scorecard.score >= 1}.count
      @gir = gir_scorecards.count
      @non_gir = non_gir_scorecards.count
      @gir_percentage = "#{((gir_scorecards.count.to_f / scorecards.count) * 100).round(2)}%"
      @non_gir_percentage = "#{((non_gir_scorecards.count.to_f / scorecards.count) * 100).round(2)}%"
      @holes_of_gir = gir_scorecards.map(&:number)
      @average_putts = (scorecards.map(&:putts).reduce(:+).to_f / scorecards.count).round(2)
      @putts_per_gir = (gir_scorecards.map(&:putts).reduce(:+).to_f / gir_scorecards.count).round(2)
      @putts_per_non_gir = (non_gir_scorecards.map(&:putts).reduce(:+).to_f / non_gir_scorecards.count).round(2)
      @double_eagle_percentage = "#{((double_eagle.to_f / scorecards.count) * 100).round(2)}%"
      @eagle_percentage = "#{((eagle.to_f / scorecards.count) * 100).round(2)}%"
      @birdie_percentage = "#{((birdie.to_f / scorecards.count) * 100).round(2)}%"
      @par_percentage = "#{((par.to_f / scorecards.count) * 100).round(2)}%"
      @bogey_percentage = "#{((bogey.to_f / scorecards.count) * 100).round(2)}%"
      @double_bogey_percentage = "#{((double_bogey.to_f / scorecards.count) * 100).round(2)}%"
      if player.scoring_type_simple?
        @longest_drive_length = par_4_and_5_scorecards.map(&:driving_distance).max
        @longest_2_drive_length = par_4_and_5_scorecards.map(&:driving_distance).sort.last(2).reduce(:+).to_f / 2
        @drive_fairways_hit = "#{((par_4_and_5_scorecards.select{|scorecard| scorecard.direction_pure?}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
      end
      if player.scoring_type_professional?
        @front_6_score = scorecards.select{|scorecard| scorecard.number >= 1 and scorecard.number <= 6}.map(&:score).reduce(:+) || 0
        @middle_6_score = scorecards.select{|scorecard| scorecard.number >= 7 and scorecard.number <= 12}.map(&:score).reduce(:+) || 0
        @last_6_score = scorecards.select{|scorecard| scorecard.number >= 13 and scorecard.number <= 18}.map(&:score).reduce(:+) || 0
        @first_putt_length = scorecards.map{|scorecard| scorecard.strokes.putt.sorted.first}.compact.map(&:distance_from_hole).instance_eval{(reduce(:+) || 0) / size.to_f}
        @first_putt_length_gir = gir_scorecards.map{|scorecard| scorecard.strokes.putt.sorted.first}.compact.map(&:distance_from_hole).instance_eval{(reduce(:+) || 0) / size.to_f}
        @first_putt_length_non_gir = non_gir_scorecards.map{|scorecard| scorecard.strokes.putt.sorted.first}.compact.map(&:distance_from_hole).instance_eval{(reduce(:+) || 0) / size.to_f}
        @holed_putt_length = scorecards.map{|scorecard| scorecard.strokes.sorted.putt.non_holed.last}.compact.map(&:distance_from_hole).reduce(:+)
        @longest_drive_length = par_4_and_5_scorecards.map{|scorecard| scorecard.distance_from_hole_to_tee_box - scorecard.strokes.first.distance_from_hole}.max
        @longest_2_drive_length = par_4_and_5_scorecards.map{|scorecard| scorecard.distance_from_hole_to_tee_box - scorecard.strokes.first.distance_from_hole}.sort.last(2).reduce(:+).to_f / 2
        @drive_fairways_hit = "#{((par_4_and_5_scorecards.select{|scorecard| ['fairway', 'green', 'bunker'].include?(scorecard.strokes.sorted.first.point_of_fall)}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
        @wasted_shots_from_drives = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.sorted.first.penalties > 0}.count
        
        @distance_0_1_from_hole_in_green = {
          per_round: scorecards.map{|scorecard| scorecard.strokes.putt.distanced(0..1)},
          shots_to_hole: 1.4,
          holed_percentage: '86%',
          dispersion: '0.12'
        }
        @distance_1_2_from_hole_in_green = { per_round: 14, shots_to_hole: 1.2, holed_percentage: '80%', dispersion: '0.08' }
        @distance_2_3_from_hole_in_green = { per_round: 11, shots_to_hole: 1.6, holed_percentage: '92%', dispersion: '0.1' }
        @distance_3_5_from_hole_in_green = { per_round: 8, shots_to_hole: 1.1, holed_percentage: '98%', dispersion: '0.13' }
        @sand_saves = 1
        @bunker_shots = 4
        @sand_saves_percentage = '25%'
        @distance_0_10_from_hole_in_bunker = { per_round: 6, shots_to_hole: 1.4, dispersion: '0.12' }
        @distance_10_20_from_hole_in_bunker = { per_round: 12, shots_to_hole: 1.1, dispersion: '0.09' }
        @distance_20_50_from_hole_in_bunker = { per_round: 19, shots_to_hole: 1.7, dispersion: '0.14' }
        @distance_50_100_from_hole_in_bunker = { per_round: 11, shots_to_hole: 1.3, dispersion: '0.28' }
        @up_and_downs = [
          { distance_from_hole: 84, putt_length: 17 },
          { distance_from_hole: 129, putt_length: 6 }
        ]
        @up_and_downs_count = 2
        @shots_within_100ft = 32
        @up_and_downs_percentage = '6%'
        @chip_ins = 0
        @longest_chip_ins_length = nil
        @gir_to_within_15ft = 1
        @gir_to_within_15ft_percentage = '10%'
        @holes_of_gir_to_within_15ft = [3]
        @drive_left_roughs_hit = '12%'
        @drive_right_roughs_hit = '23%'
        @drive_fairways_count = 23
        @drive_left_roughs_count = 7
        @drive_right_roughs_count = 2
        @holes_of_drive_fairways = [1, 3, 4, 5, 6, 7, 8, 13, 15, 17, 18]
        @holes_of_drive_left_roughs = [2, 9, 11]
        @holes_of_drive_right_roughs = [10, 12, 14, 16]
        @good_drives = 12
        @good_drives_percentage = '93%'
        @holes_of_good_drives = [1, 2, 6, 11]
        @club_1w = { uses: 20, average_length: 160, minimum_length: 30, maximum_length: 210, less_than_average_length: 7, greater_than_average_length: 18 }
        @club_3w = { uses: 1, average_length: 320, minimum_length: 320, maximum_length: 320, less_than_average_length: nil, greater_than_average_length: nil }
        @club_5w = { uses: 3, average_length: 130, minimum_length: 80, maximum_length: 190, less_than_average_length: 2, greater_than_average_length: 10 }
        @club_7w = { uses: 8, average_length: 70, minimum_length: 50, maximum_length: 135, less_than_average_length: 5, greater_than_average_length: 3 }
      end
    end
  end

  def calculate!
    scorecards = player.scorecards.finished
    self.score = scorecards.map(&:score).reduce(:+)
    self.net = scorecards.map(&:score).reduce(:+)
    self.putts = scorecards.map(&:putts).reduce(:+)
    self.penalties = scorecards.map(&:penalties).reduce(:+)
    self.score_par_3 = scorecards.select{|scorecard| scorecard.par == 3}.map(&:score).reduce(:+)
    self.score_par_4 = scorecards.select{|scorecard| scorecard.par == 4}.map(&:score).reduce(:+)
    self.score_par_5 = scorecards.select{|scorecard| scorecard.par == 5}.map(&:score).reduce(:+)
    self.double_eagle = scorecards.select{|scorecard| scorecard.par - scorecard.score >= 3}.count
    self.eagle = scorecards.select{|scorecard| scorecard.par - scorecard.score == 2}.count
    self.birdie = scorecards.select{|scorecard| scorecard.par - scorecard.score == 1}.count
    self.par = scorecards.select{|scorecard| scorecard.par == scorecard.score}.count
    self.bogey = scorecards.select{|scorecard| scorecard.score - scorecard.par == 1}.count
    self.double_bogey = scorecards.select{|scorecard| scorecard.score - scorecard.par >= 2}.count
    save!
  end
end
