class CustomizedStatistic
  attr_accessor :score_par_3
  attr_accessor :score_par_4
  attr_accessor :score_par_5
  attr_accessor :score
  attr_accessor :putts
  attr_accessor :gir
  attr_accessor :putts_per_gir
  attr_accessor :longest_drive_length
  attr_accessor :average_drive_length
  attr_accessor :double_eagle
  attr_accessor :eagle
  attr_accessor :birdie
  attr_accessor :par
  attr_accessor :bogey
  attr_accessor :double_bogey

  def initialize method, options = {}
    @score_par_3 = 12
    @score_par_4 = 12
    @score_par_5 = 12
    @score = 12
    @putts = 12
    @gir = 12
    @putts_per_gir = 12
    @longest_drive_length = 12
    @average_drive_length = 12
    @double_eagle = 12
    @eagle = 12
    @birdie = 12
    @par = 12
    @bogey = 12
    @double_bogey = 12
  end
end