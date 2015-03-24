class Statistic < ActiveRecord::Base
  belongs_to :player

  def calculate!
    scorecards = player.scorecards
    if scorecards.all?{|scorecard| scorecard.score}
      par_4_and_5_scorecards = scorecards.select{|scorecard| scorecard.par > 3}
      gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts - scorecard.penalties) <= (scorecard.par - 2)}
      non_gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts - scorecard.penalties) > (scorecard.par - 2)}
      self.score = scorecards.map(&:score).reduce(:+)
      self.net = scorecards.map(&:score).reduce(:+)
      self.putts = scorecards.map(&:putts).reduce(:+)
      self.penalties = scorecards.map(&:penalties).reduce(:+)
      self.longest_drive_length = par_4_and_5_scorecards.map(&:driving_distance).max
      self.average_drive_length = (par_4_and_5_scorecards.map(&:driving_distance).reduce(:+).to_f / par_4_and_5_scorecards.count).round(2)
      self.drive_fairways_hit = "#{((par_4_and_5_scorecards.select{|scorecard| scorecard.direction_pure?}.count.to_f / par_4_and_5_scorecards.count) * 100).round(2)}%"
      self.scrambles = "#{((non_gir_scorecards.select{|scorecard| scorecard.score <= scorecard.par}.count.to_f / non_gir_scorecards.count) * 100).round(2)}%"
      self.bounce = scorecards.inject(previous: nil, bounce: 0) do |result, scorecard|
        if scorecard.score - scorecard.par >= 1
          result[:previous] = 'bogey+'
        elsif scorecard.par - scorecard.score >= 1
          result[:bounce] += 1 if result[:previous] == 'bogey+'
          result[:previous] = 'birdie+'
        else
          result[:previous] = 'par'
        end
        result
      end[:bounce]
      self.advantage_transformation = gir_scorecards.select{|scorecard| scorecard.par - scorecard.score >= 1}.count
      self.greens_in_regulation = "#{((gir_scorecards.count.to_f / 18) * 100).round(2)}%"
      self.putts_per_gir = (gir_scorecards.map(&:putts).reduce(:+).to_f / gir_scorecards.count).round(2)
      self.score_par_3 = scorecards.select{|scorecard| scorecard.par == 3}.map(&:score).reduce(:+)
      self.score_par_4 = scorecards.select{|scorecard| scorecard.par == 4}.map(&:score).reduce(:+)
      self.score_par_5 = scorecards.select{|scorecard| scorecard.par == 5}.map(&:score).reduce(:+)
      self.double_eagle = scorecards.select{|scorecard| scorecard.par - scorecard.score >= 3}.count
      self.eagle = scorecards.select{|scorecard| scorecard.par - scorecard.score == 2}.count
      self.birdie = scorecards.select{|scorecard| scorecard.par - scorecard.score == 1}.count
      self.par = scorecards.select{|scorecard| scorecard.par == scorecard.score}.count
      self.bogey = scorecards.select{|scorecard| scorecard.score - scorecard.par == 1}.count
      self.double_bogey = scorecards.select{|scorecard| scorecard.score - scorecard.par >= 2}.count
    end
    save!
  end
end
