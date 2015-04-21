class CustomizedStatistic
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
  attr_accessor :finished_count

  def initialize method, user, options = {}
    players = case method
    when :by_match
      if options[:matches_count] == 'all'
        user.players
      else
        user.players.order(created_at: :desc).limit(options[:matches_count].to_i)
      end
    when :by_date
      user.players.where('created_at >= ?', Time.at(options[:date_begin]).to_date).where('created_at <= ?', Time.at(options[:date_end]).to_date)
    when :by_venue
      user.players.joins(:match).where(matches: { venue_id: Venue.find_uuid(options[:venue_uuid]).id })
    end.select{|player| player.finished?}
    scorecards = players.map(&:scorecards).flatten
    unless players.count.zero?
      @finished_count = players.count
      @score_par_3 = (scorecards.select{|scorecard| scorecard.par == 3}.map(&:score).reduce(:+).to_f / scorecards.select{|scorecard| scorecard.par == 3}.count).round(2)
      @score_par_4 = (scorecards.select{|scorecard| scorecard.par == 4}.map(&:score).reduce(:+).to_f / scorecards.select{|scorecard| scorecard.par == 4}.count).round(2)
      @score_par_5 = (scorecards.select{|scorecard| scorecard.par == 5}.map(&:score).reduce(:+).to_f / scorecards.select{|scorecard| scorecard.par == 5}.count).round(2)
      @score = (players.map(&:score).reduce(:+).to_f / players.count).round(2)
      @handicap = 2
      @putts = (players.map(&:putts).reduce(:+).to_f / players.count).round(2)
      @gir = "#{((players.map{|player| player.scorecards.select{|scorecard| (scorecard.score - scorecard.putts) <= (scorecard.par - 2)}.count.to_f / 18}.reduce(:+) / players.count) * 100).round(2)}%"
      @putts_per_gir = 12
      @average_drive_length = 12
      @drive_fairways_hit = "#{((scorecards.select{|scorecard| scorecard.par > 3 and scorecard.direction_pure?}.count.to_f / (players.count * 14)) * 100).round(2)}%"
      @advantage_transformation = '2%'
      @bounce = '2%'
      @double_eagle = (scorecards.select{|scorecard| scorecard.par - scorecard.score >= 3}.count / players.count).round(2)
      @eagle = (scorecards.select{|scorecard| scorecard.par - scorecard.score == 2}.count / players.count).round(2)
      @birdie = (scorecards.select{|scorecard| scorecard.par - scorecard.score == 1}.count / players.count).round(2)
      @par = (scorecards.select{|scorecard| scorecard.par == scorecard.score}.count / players.count).round(2)
      @bogey = (scorecards.select{|scorecard| scorecard.score - scorecard.par == 1}.count / players.count).round(2)
      @double_bogey = (scorecards.select{|scorecard| scorecard.score - scorecard.par > 1}.count / players.count).round(2)
    end
  end
end