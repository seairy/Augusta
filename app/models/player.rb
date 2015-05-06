class Player < ActiveRecord::Base
  as_enum :scoring_type, [:simple, :professional], prefix: true, map: :string
  belongs_to :user
  belongs_to :match, counter_cache: true
  has_one :statistic
  has_many :scorecards, -> { order(:number) }
  scope :by_user, ->(user) { where(user_id: user.id) }
  scope :latest, -> { order(created_at: :desc) }

  def recorded_scorecards_count
    scorecards.select(&:score).count
  end

  def par
    scorecards.map(&:par).reduce(:+)
  end

  def out_par
    scorecards.out.map(&:par).reduce(:+)
  end

  def in_par
    scorecards.in.map(&:par).reduce(:+)
  end

  def score
    scorecards.map(&:score).compact.reduce(:+) || 0
  end

  def out_score
    scorecards.out.map(&:score).compact.reduce(:+)
  end

  def in_score
    scorecards.in.map(&:score).compact.reduce(:+)
  end

  def status
    scorecards.map(&:status).compact.reduce(:+)
  end

  def out_status
    scorecards.out.map(&:status).compact.reduce(:+)
  end

  def in_status
    scorecards.in.map(&:status).compact.reduce(:+)
  end

  def net

  end

  def putts
    scorecards.map(&:putts).compact.reduce(:+)
  end

  def penalties
    scorecards.in.map(&:penalties).compact.reduce(:+)
  end

  def finished?
    scorecards.select(&:score).count == 18
  end
end
