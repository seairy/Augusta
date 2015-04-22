class CustomizedStatistic
  attr_accessor :finished_count
  attr_accessor :score_par_3
  attr_accessor :score_par_4
  attr_accessor :score_par_5
  attr_accessor :score
  attr_accessor :handicap
  attr_accessor :putts
  attr_accessor :gir
  attr_accessor :putts_per_gir
  attr_accessor :average_drive_length
  attr_accessor :drive_fairways_hit
  attr_accessor :advantage_transformation
  attr_accessor :bounce
  attr_accessor :double_eagle
  attr_accessor :eagle
  attr_accessor :birdie
  attr_accessor :par
  attr_accessor :bogey
  attr_accessor :double_bogey

  def initialize method, user, options = {}
    players = case method
    when :by_match
      if options[:matches_count] == 'all'
        user.players
      else
        user.players.order(created_at: :desc).limit(options[:matches_count].to_i)
      end
    when :by_date
      user.players.where('created_at >= ?', Time.at(options[:date_begin]).beginning_of_day.utc).where('created_at <= ?', Time.at(options[:date_end]).end_of_day.utc)
    when :by_venue
      user.players.joins(:match).where(matches: { venue_id: Venue.find_uuid(options[:venue_uuid]).id })
    end.select{|player| player.finished? and player.match}
    scorecards = Scorecard.where(player_id: players.map(&:id))
    gir_scorecards = scorecards.select{|scorecard| (scorecard.score - scorecard.putts) <= (scorecard.par - 2)}
    par_4_and_5_scorecards = scorecards.select{|scorecard| scorecard.par > 3}
    @finished_count = players.count
    unless players.count.zero?
      @score_par_3 = (scorecards.select{|scorecard| scorecard.par == 3}.map(&:score).reduce(:+).to_f / scorecards.select{|scorecard| scorecard.par == 3}.count).round(2)
      @score_par_4 = (scorecards.select{|scorecard| scorecard.par == 4}.map(&:score).reduce(:+).to_f / scorecards.select{|scorecard| scorecard.par == 4}.count).round(2)
      @score_par_5 = (scorecards.select{|scorecard| scorecard.par == 5}.map(&:score).reduce(:+).to_f / scorecards.select{|scorecard| scorecard.par == 5}.count).round(2)
      @score = (players.map(&:score).reduce(:+).to_f / players.count).round(2)
      @handicap = 2
      @putts = (players.map(&:putts).reduce(:+).to_f / players.count).round(2)
      @gir = "#{((gir_scorecards.count.to_f / scorecards.count) * 100).round(2)}%"
      @putts_per_gir = gir_scorecards.count.zero? ? 0 : (gir_scorecards.map(&:putts).reduce(:+).to_f / gir_scorecards.count).round(2)
      @average_drive_length = (par_4_and_5_scorecards.map(&:driving_distance).reduce(:+).to_f / par_4_and_5_scorecards.count).round(2)
      @drive_fairways_hit = "#{((scorecards.select{|scorecard| scorecard.par > 3 and scorecard.direction_pure?}.count.to_f / (players.count * 14)) * 100).round(2)}%"
      @advantage_transformation = gir_scorecards.select{|scorecard| scorecard.par - scorecard.score >= 1}.count
      @bounce = "#{((players.map{|player| player.scorecards.inject(previous: nil, bounce: 0) do |result, scorecard|
        if scorecard.score - scorecard.par >= 1
          result[:previous] = 'bogey+'
        elsif scorecard.par - scorecard.score >= 1
          result[:bounce] += 1 if result[:previous] == 'bogey+'
          result[:previous] = 'birdie+'
        else
          result[:previous] = 'par'
        end
        result
      end[:bounce].to_f / 9}.reduce(:+) / players.count) * 100).round(2)}%"
      @double_eagle = (scorecards.select{|scorecard| scorecard.par - scorecard.score >= 3}.count / players.count).round(2)
      @eagle = (scorecards.select{|scorecard| scorecard.par - scorecard.score == 2}.count / players.count).round(2)
      @birdie = (scorecards.select{|scorecard| scorecard.par - scorecard.score == 1}.count / players.count).round(2)
      @par = (scorecards.select{|scorecard| scorecard.par == scorecard.score}.count / players.count).round(2)
      @bogey = (scorecards.select{|scorecard| scorecard.score - scorecard.par == 1}.count / players.count).round(2)
      @double_bogey = (scorecards.select{|scorecard| scorecard.score - scorecard.par > 1}.count / players.count).round(2)
    end
  end
end