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
  attr_accessor :greens_in_regulation
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
  after_initialize :setup_after_initialize

  def setup_after_initialize
    scorecards = player.scorecards
    if scorecards.all?{|scorecard| scorecard.score}
      par_4_and_5_scorecards = scorecards.select{|scorecard| scorecard.par > 3}
      gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts - scorecard.penalties) <= (scorecard.par - 2)}
      non_gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts - scorecard.penalties) > (scorecard.par - 2)}
      @longest_drive_length = par_4_and_5_scorecards.map(&:driving_distance).max
      @average_drive_length = (par_4_and_5_scorecards.map(&:driving_distance).reduce(:+).to_f / par_4_and_5_scorecards.count).round(2)
      @drive_fairways_hit = "#{((par_4_and_5_scorecards.select{|scorecard| scorecard.direction_pure?}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
      @scrambles = "#{((non_gir_scorecards.select{|scorecard| scorecard.score <= scorecard.par}.count.to_f / non_gir_scorecards.count) * 100).round(2)}%"
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
      @greens_in_regulation = "#{((gir_scorecards.count.to_f / 18) * 100).round(2)}%"
      @average_putts = (scorecards.map(&:putts).reduce(:+).to_f / 18).round(2)
      @putts_per_gir = (gir_scorecards.map(&:putts).reduce(:+).to_f / gir_scorecards.count).round(2)
      @putts_per_non_gir = (non_gir_scorecards.map(&:putts).reduce(:+).to_f / non_gir_scorecards.count).round(2)
      if player.scoring_type_professional?
        @front_6_score = scorecards.select{|scorecard| scorecard.number >= 1 and scorecard.number <= 6}.map(&:score).reduce(:+)
        @middle_6_score = scorecards.select{|scorecard| scorecard.number >= 7 and scorecard.number <= 12}.map(&:score).reduce(:+)
        @last_6_score = scorecards.select{|scorecard| scorecard.number >= 13 and scorecard.number <= 18}.map(&:score).reduce(:+)
        @first_putt_length = scorecards.map{|scorecard| scorecard.strokes.putt.sorted.first}.compact.map(&:distance_from_hole).instance_eval{(reduce(:+) || 0) / size.to_f}
        @first_putt_length_gir = gir_scorecards.map{|scorecard| scorecard.strokes.putt.sorted.first}.compact.map(&:distance_from_hole).instance_eval{(reduce(:+) || 0) / size.to_f}
        @first_putt_length_non_gir = non_gir_scorecards.map{|scorecard| scorecard.strokes.putt.sorted.first}.compact.map(&:distance_from_hole).instance_eval{(reduce(:+) || 0) / size.to_f}
        # @holed_putt_length = scorecards.map do |scorecard|
        #   last_putts = scorecard.strokes.sorted.putt.last(2)
        #   if last_putts.count == 2
        #     last_putts.last.distance_from_hole == 0 ? last_putts.first : last_putts.last
        #   elsif last_putts.count == 1

        #   end
        # end
        @scrambles_percentage = '17%'
        @non_gir = 14
        @wasted_shots_from_drives = 2
        @holed_putt_length = 1.8
        @distance_0_1_from_hole_in_green = { per_round: 17, shots_to_hole: 1.4, holed_percentage: '86%', dispersion: '0.12'}
        @distance_1_2_from_hole_in_green = { per_round: 14, shots_to_hole: 1.2, holed_percentage: '80%', dispersion: '0.08'}
        @distance_2_3_from_hole_in_green = { per_round: 11, shots_to_hole: 1.6, holed_percentage: '92%', dispersion: '0.1'}
        @distance_3_5_from_hole_in_green = { per_round: 8, shots_to_hole: 1.1, holed_percentage: '98%', dispersion: '0.13'}
        @sand_saves = 1
        @bunker_shots = 4
        @sand_saves_percentage = '25%'
        @distance_0_10_from_hole_in_bunker = { per_round: 6, shots_to_hole: 1.4, dispersion: '0.12'}
        @distance_10_20_from_hole_in_bunker = { per_round: 12, shots_to_hole: 1.1, dispersion: '0.09'}
        @distance_20_50_from_hole_in_bunker = { per_round: 19, shots_to_hole: 1.7, dispersion: '0.14'}
        @distance_50_100_from_hole_in_bunker = { per_round: 11, shots_to_hole: 1.3, dispersion: '0.28'}
        @up_and_downs = [
          { distance_from_hole: 84, putt_length: 17},
          { distance_from_hole: 129, putt_length: 6},
        ]
        @up_and_downs_count = 2
        @shots_within_100ft = 32
        @up_and_downs_percentage = '6%'
        @chip_ins = 0
        @longest_chip_ins_length = nil
        @gir_percentage = '65%'
        @non_gir_percentage = '35%'
        @holes_of_gir = [1, 3, 5, 12, 18]
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
        @double_eagle_percentage = '12%'
        @eagle_percentage = '22%'
        @birdie_percentage = '9%'
        @par_percentage = '19%'
        @bogey_percentage = '37%'
        @double_bogey_percentage = '0%'
        @club_1w = { uses: 20, average_length: 160, minimum_length: 30, maximum_length: 210, less_than_average_length: 7, greater_than_average_length: 18 }
        @club_3w = { uses: 1, average_length: 320, minimum_length: 320, maximum_length: 320, less_than_average_length: nil, greater_than_average_length: nil }
        @club_5w = { uses: 3, average_length: 130, minimum_length: 80, maximum_length: 190, less_than_average_length: 2, greater_than_average_length: 10 }
        @club_7w = { uses: 8, average_length: 70, minimum_length: 50, maximum_length: 135, less_than_average_length: 5, greater_than_average_length: 3 }
      end
    end
  end

  def calculate!
    scorecards = player.scorecards
    if scorecards.all?{|scorecard| scorecard.score}
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
end
