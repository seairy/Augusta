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

  def double_eagle?
    par - score > 2
  end

  def eagle?
    par - score == 2
  end

  def birdie?
    par - score == 1
  end

  def par?
    score == par
  end

  def bogey?
    score - par == 1
  end

  def double_bogey?
    score - par > 1
  end

  def finished?
    score
  end

  def status
    score - par if score and par
  end

  def distance_from_hole
    distance_from_hole_to_tee_box - driving_distance if driving_distance
  end

  def up_and_downs?
    (strokes.last.sequence == 1 and distance_from_hole_to_tee_box <= 100) or
    (strokes.last.sequence == 2 and strokes.last.club_pt? and distance_from_hole_to_tee_box <= 100) or
    (strokes.last.sequence == 2 and !strokes.last.club_pt? and strokes.last.distance_from_hole <= 100) or
    (strokes.last.sequence > 2 and strokes.last.club_pt? and !strokes.last(2).first.club_pt? and strokes.last(3)[0].distance_from_hole <= 100) or
    (strokes.last.sequence > 2 and !strokes.last.club_pt? and strokes.last(2).first.distance_from_hole <= 100)
  end

  def chip_ins?
    strokes.select{|stroke| stroke.club_pt?}.count.zero?
  end

  def update_simple options = {}
    options[:driving_distance] = (distance_from_hole_to_tee_box - options.delete(:distance_from_hole)).abs
    update!(options)
    calculate_player_and_statistic_and_leaderboard!
  end

  def update_professional options = {}
    ActiveRecord::Base.transaction do
      strokes.map(&:destroy!)
      new_strokes = options[:strokes].map do |stroke_params|
        Stroke.new(scorecard: self, distance_from_hole: stroke_params[:distance_from_hole], point_of_fall: stroke_params[:point_of_fall], penalties: stroke_params[:penalties], club: stroke_params[:club])
      end
      raise HoledStrokeNotFound.new unless new_strokes.last.distance_from_hole.zero?
      raise DuplicatedHoledStroke.new if new_strokes.select{|stroke| stroke.distance_from_hole.zero?}.count > 1
      new_strokes.map(&:save!)
      self.putts = strokes.reload.select{|stroke| stroke.club_pt?}.count
      self.penalties = (strokes.map{|stroke| stroke.penalties}.compact.reduce(:+) || 0)
      self.score = strokes.count + self.penalties
      self.driving_distance = (distance_from_hole_to_tee_box - strokes.first.distance_from_hole).abs if strokes.first
      self.direction = (if strokes.first.point_of_fall_left_rough?
          :hook
        elsif strokes.first.point_of_fall_right_rough?
          :slice
        else
          :pure
        end) if strokes.first
      save!
    end
    calculate_player_and_statistic_and_leaderboard!
  end

  def calculate_player_and_statistic_and_leaderboard!
    player.calculate!
    player.statistic.calculate!
    player.match.calculate_leaderboard!
  end
end