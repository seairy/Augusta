class Statistic < ActiveRecord::Base
  belongs_to :player
  attr_accessor :front_6_score
  attr_accessor :middle_6_score
  attr_accessor :last_6_score
  attr_accessor :longest_drive_length
  attr_accessor :longest_drive_length
  attr_accessor :longest_drive_length
  attr_accessor :average_drive_length
  attr_accessor :drive_fairways_hit
  attr_accessor :scrambles
  attr_accessor :bounce
  attr_accessor :advantage_transformation
  attr_accessor :greens_in_regulation
  attr_accessor :average_putts
  attr_accessor :putts_per_gir
  attr_accessor :putts_per_non_gir
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length_gir
  attr_accessor :first_putt_length_non_gir
  attr_accessor :holed_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
  attr_accessor :first_putt_length
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
        @first_putt_length = scorecards.map{|scorecard| scorecard.strokes.sorted.putt.first}.compact.map(&:distance_from_hole).instance_eval{reduce(:+) / size.to_f}
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
