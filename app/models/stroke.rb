class Stroke < ActiveRecord::Base
  include UUID
  belongs_to :scorecard
  as_enum :point_of_fall, [:fairway, :green, :left_rough, :right_rough, :bunker, :unplayable], prefix: true, map: :string
  as_enum :club, ['1w', '3w'], prefix: true, map: :string
  before_create :setup_sequence
  after_destroy :reorder_sequence
  scope :by_scorecard, ->(scorecard_id) { where(scorecard_id: scorecard_id) }
  scope :sorted, -> { order(:sequence) }

  protected
    def setup_sequence
      self.sequence = Stroke.by_scorecard(self.scorecard).count + 1
    end

    def reorder_sequence
      Stroke.by_scorecard(self.scorecard).each_with_index.map{|stroke, i| stroke.update!(sequence: i + 1)}
    end
end
