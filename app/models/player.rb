class Player < ActiveRecord::Base
  as_enum :scoring_type, [:simple, :professional], prefix: true, map: :string
  belongs_to :user
  belongs_to :match
  has_one :statistic
  has_many :scorecards, -> { order(:number) }
end
