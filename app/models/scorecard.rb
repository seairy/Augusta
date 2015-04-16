# -*- encoding : utf-8 -*-
class Scorecard < ActiveRecord::Base
  include UUID
  as_enum :tee_box_color, [:red, :white, :blue, :black, :gold], prefix: true, map: :string
  as_enum :direction, [:hook, :pure, :slice], prefix: true, map: :string
  belongs_to :player
  belongs_to :hole
  has_many :strokes
  scope :finished, -> { where.not(score: nil) }
  scope :sorted, -> { order(:number) }
  scope :out, -> { where(number: 1..9) }
  scope :in, -> { where(number: 10..18) }

  def finished?
    score
  end

  def status
    score - par if score and par
  end

  def up_and_downs?
    strokes.count >= 3 and strokes.last(3)[0].instance_eval{distance_from_hole <= 100 and point_of_fall_fairway?} and strokes.last(3)[1].instance_eval{point_of_fall_green?}
  end

  def chip_ins?
    strokes.count >= 2 and strokes.last(2)[0].instance_eval{distance_from_hole <= 100 and point_of_fall_fairway?}
  end

  def calculate!
    if player.scoring_type_professional?
      self.putts = strokes.select{|stroke| stroke.club_pt?}.count
      self.penalties = (strokes.map{|stroke| stroke.penalties}.compact.reduce(:+) || 0)
      self.score = strokes.count + self.penalties
      self.driving_distance = (distance_from_hole_to_tee_box - strokes.first.distance_from_hole) if strokes.first
      self.direction = (if strokes.first.point_of_fall_left_rough?
          :hook
        elsif strokes.first.point_of_fall_right_rough?
          :slice
        else
          :pure
        end) if strokes.first
      save!
    end
  end
end