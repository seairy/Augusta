class Statistic < ActiveRecord::Base
  belongs_to :player
  attr_accessor :average_score_par_3
  attr_accessor :average_score_par_4
  attr_accessor :average_score_par_5
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
  attr_accessor :shots_within_100
  attr_accessor :up_and_downs_percentage
  attr_accessor :chip_ins
  attr_accessor :longest_chip_ins_length
  attr_accessor :holes_of_gir
  attr_accessor :gir_to_within_5
  attr_accessor :gir_to_within_5_percentage
  attr_accessor :holes_of_gir_to_within_5
  attr_accessor :good_drives
  attr_accessor :good_drives_percentage
  attr_accessor :holes_of_good_drives
  attr_accessor :frequently_used_clubs
  attr_accessor :clubs

  after_initialize :setup_after_initialize

  def setup_after_initialize
    scorecards = player.scorecards.finished
    if scorecards.any?
      strokes = Stroke.where(scorecard_id: scorecards.map(&:id))
      par_4_and_5_scorecards = scorecards.select{|scorecard| scorecard.par > 3}
      gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts) <= (scorecard.par - 2)}
      non_gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts) > (scorecard.par - 2)}
      @average_score_par_3 = score_par_3.nil? ? 0 : (score_par_3.to_f / scorecards.select{|scorecard| scorecard.par == 3}.count).round(2)
      @average_score_par_4 = score_par_4.nil? ? 0 : (score_par_4.to_f / scorecards.select{|scorecard| scorecard.par == 4}.count).round(2)
      @average_score_par_5 = score_par_5.nil? ? 0 : (score_par_5.to_f / scorecards.select{|scorecard| scorecard.par == 5}.count).round(2)
      @scrambles = non_gir_scorecards.select{|scorecard| scorecard.score <= scorecard.par}.count || 0
      @scrambles_percentage = "#{non_gir_scorecards.count.zero? ? 0 : ((@scrambles.to_f / non_gir_scorecards.count) * 100).round(2)}%"
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
        @average_drive_length = (par_4_and_5_scorecards.map(&:driving_distance).reduce(:+).to_f / par_4_and_5_scorecards.count).round(2)
        @longest_drive_length = par_4_and_5_scorecards.map(&:driving_distance).max
        @longest_2_drive_length = (par_4_and_5_scorecards.map(&:driving_distance).sort.last(2).reduce(:+).to_f / 2).round(2)
        @drive_fairways_hit = "#{((par_4_and_5_scorecards.select{|scorecard| scorecard.direction_pure?}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
      end
      if player.scoring_type_professional?
        @front_6_score = scorecards.select{|scorecard| scorecard.number >= 1 and scorecard.number <= 6}.map(&:score).reduce(:+) || 0
        @middle_6_score = scorecards.select{|scorecard| scorecard.number >= 7 and scorecard.number <= 12}.map(&:score).reduce(:+) || 0
        @last_6_score = scorecards.select{|scorecard| scorecard.number >= 13 and scorecard.number <= 18}.map(&:score).reduce(:+) || 0
        @first_putt_length = scorecards.map{|scorecard| scorecard.strokes.shot.point_of_fall_greens.last.try(:distance_from_hole)}.compact.instance_eval{(reduce(:+) || 0).to_f / 18}.round(2)
        @first_putt_length_gir = gir_scorecards.count.zero? ? 0 : gir_scorecards.map{|scorecard| scorecard.strokes.shot.point_of_fall_greens.last.try(:distance_from_hole)}.compact.instance_eval{(reduce(:+) || 0).to_f / gir_scorecards.count}.round(2)
        @first_putt_length_non_gir = non_gir_scorecards.count.zero? ? 0 : non_gir_scorecards.map{|scorecard| scorecard.strokes.shot.point_of_fall_greens.last.try(:distance_from_hole)}.compact.instance_eval{(reduce(:+) || 0).to_f / non_gir_scorecards.count}.round(2)
        @holed_putt_length = scorecards.map do |scorecard|
          last_stroke = scorecard.strokes.last
          last_stroke.previous.distance_from_hole if last_stroke.club_pt?
        end.compact.instance_eval{(reduce(:+) || 0).to_f / 18}.round(2)
        [0..1, 1..2, 2..3, 3..5].each do |distance_range|
          eval("@distance_#{distance_range.begin}_#{distance_range.end}_from_hole_in_green = {
            per_round: strokes.point_of_fall_greens.distance(#{distance_range}).count,
            shots_to_hole: 0,
            holed_percentage: 0,
            dispersion: 0,
          }")
        end
        par_4_and_5_drived_scorecards = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.club_1w?}
        @average_drive_length = par_4_and_5_drived_scorecards.count.zero? ? 0 : (par_4_and_5_drived_scorecards.map{|scorecard| scorecard.distance_from_hole_to_tee_box - scorecard.strokes.first.distance_from_hole}.compact.reduce(:+).to_f / par_4_and_5_drived_scorecards.count).round(2)
        @longest_drive_length = par_4_and_5_scorecards.map{|scorecard| scorecard.distance_from_hole_to_tee_box - scorecard.strokes.first.distance_from_hole if scorecard.strokes.first.club_1w?}.compact.max
        @longest_2_drive_length = (par_4_and_5_scorecards.map{|scorecard| scorecard.distance_from_hole_to_tee_box - scorecard.strokes.first.distance_from_hole if scorecard.strokes.first.club_1w?}.compact.sort.last(2).reduce(:+).to_f / 2).round(2)
        @drive_fairways_hit = "#{par_4_and_5_scorecards.count.zero? ? 0 : ((par_4_and_5_scorecards.select{|scorecard| [:fairway, :green, :bunker].include?(scorecard.strokes.first.point_of_fall)}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
        @drive_left_roughs_hit = "#{par_4_and_5_scorecards.count.zero? ? 0 : ((par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.point_of_fall_left_rough?}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
        @drive_right_roughs_hit = "#{par_4_and_5_scorecards.count.zero? ? 0 : ((par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.point_of_fall_right_rough?}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
        @drive_fairways_count = par_4_and_5_scorecards.select{|scorecard| [:fairway, :green, :bunker].include?(scorecard.strokes.first.point_of_fall)}.count
        @drive_left_roughs_count = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.point_of_fall_left_rough?}.count
        @drive_right_roughs_count = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.point_of_fall_right_rough?}.count
        @holes_of_drive_fairways = par_4_and_5_scorecards.select{|scorecard| [:fairway, :green, :bunker].include?(scorecard.strokes.first.point_of_fall)}.map(&:number)
        @holes_of_drive_left_roughs = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.point_of_fall_left_rough?}.map(&:number)
        @holes_of_drive_right_roughs = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.point_of_fall_right_rough?}.map(&:number)
        @wasted_shots_from_drives = par_4_and_5_scorecards.select{|scorecard| scorecard.strokes.first.penalties > 0}.count
        @sand_saves = scorecards.select do |scorecard|
          stroke = scorecard.strokes.distance_within_40.point_of_fall_bunkers.last
          stroke.next.holed? or (stroke.next.point_of_fall_green? and stroke.next.next.holed?) if stroke
        end.count
        @bunker_shots = scorecards.map{|scorecard| scorecard.strokes.distance_within_40.point_of_fall_bunkers.count}.reduce(:+)
        @sand_saves_percentage = "#{@bunker_shots.zero? ? 0 : ((@sand_saves.to_f / @bunker_shots) * 100).round(2)}%"
        [0..10, 10..20, 20..50, 50..100].each do |distance_range|
          eval("@distance_#{distance_range.begin}_#{distance_range.end}_from_hole_in_bunker = {
            per_round: scorecards.map{|scorecard| scorecard.strokes.distance(#{distance_range}).point_of_fall_bunkers.count}.reduce(:+),
            shots_to_hole: scorecards.map{|scorecard| scorecard.strokes.distance(#{distance_range}).point_of_fall_bunkers}.flatten.map{|stroke| stroke.shots_to_hole}.instance_eval{(reduce(:+) || 0) / size.to_f},
            dispersion: scorecards.map{|scorecard| scorecard.strokes.distance(#{distance_range}).point_of_fall_bunkers}.flatten.map{|stroke| stroke.next.distance_from_hole}.instance_eval{(reduce(:+) || 0) / size.to_f}
          }")
        end
        up_and_downs_scorecards = scorecards.select{|scorecard| scorecard.up_and_downs?}
        @up_and_downs = up_and_downs_scorecards.map do |scorecard|
          if scorecard.strokes.last.club_pt?
            { distance_from_hole: scorecard.strokes.last(3)[0].distance_from_hole,
              putt_length: scorecard.strokes.last(3)[1].distance_from_hole }
          elsif scorecard.chip_ins?
            { distance_from_hole: scorecard.strokes.last(2).first.distance_from_hole,
              putt_length: 0 }
          end
        end
        @up_and_downs_count = up_and_downs_scorecards.count
        @shots_within_100 = scorecards.map{|scorecard| scorecard.strokes.non_holed.select{|stroke| stroke.distance_from_hole <= 100 and !stroke.point_of_fall_green?}.count}.reduce(:+) + scorecards.select{|scorecard| scorecard.distance_from_hole_to_tee_box <= 100}.count
        @up_and_downs_percentage = "#{@shots_within_100.zero? ? 0 : ((@up_and_downs_count.to_f / @shots_within_100) * 100).round(2)}%"
        @chip_ins = scorecards.select{|scorecard| scorecard.chip_ins?}.count
        @longest_chip_ins_length = up_and_downs_scorecards.select{|scorecard| scorecard.chip_ins?}.map{|scorecard| scorecard.strokes.last(2).first.distance_from_hole}.max
        gir_to_within_5_scorecards = gir_scorecards.select{|scorecard| scorecard.strokes.shot.last.distance_from_hole <= 5}
        @gir_to_within_5 = gir_to_within_5_scorecards.count
        @gir_to_within_5_percentage = "#{gir_scorecards.count.zero? ? 0 : ((@gir_to_within_5.to_f / 18) * 100).round(2)}%"
        @holes_of_gir_to_within_5 = gir_to_within_5_scorecards.map(&:number)
        good_drives_scorecards = par_4_and_5_scorecards.select do |scorecard|
          [:left_rough, :right_rought, :bunker, :unplayable].include?(scorecard.strokes.first.point_of_fall) and
          (scorecard.score - scorecard.putts - scorecard.penalties) <= (scorecard.par - 2)
        end
        drive_not_in_fairway_scorecards = par_4_and_5_scorecards.select{|scorecard| [:left_rough, :right_rought, :unplayable].include?(scorecard.strokes.first.point_of_fall)}
        @good_drives = good_drives_scorecards.count
        @good_drives_percentage = "#{drive_not_in_fairway_scorecards.count.zero? ? 0 : ((@good_drives.to_f / drive_not_in_fairway_scorecards.count) * 100).round(2)}%"
        @holes_of_good_drives = good_drives_scorecards.map(&:number)
        @clubs = Stroke.clubs.keys.map do |club|
          club_average_length = strokes.send("club_#{club}s").count.zero? ? 0 : (strokes.send("club_#{club}s").map(&:distance_from_hole).reduce(:+).to_f / strokes.send("club_#{club}s").count).round(2)
          { name: club,
            uses: strokes.send("club_#{club}s").count,
            average_length: club_average_length,
            minimum_length: strokes.send("club_#{club}s").map(&:distance_from_hole).min,
            maximum_length: strokes.send("club_#{club}s").map(&:distance_from_hole).max,
            less_than_average_length: strokes.send("club_#{club}s").select{|stroke| stroke.distance_from_hole < club_average_length}.count,
            greater_than_average_length: strokes.send("club_#{club}s").select{|stroke| stroke.distance_from_hole > club_average_length}.count }
        end
        @frequently_used_clubs = @clubs.sort{|x, y| y[:uses] <=> x[:uses]}[0..3]
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
