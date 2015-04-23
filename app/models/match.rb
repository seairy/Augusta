# -*- encoding : utf-8 -*-
class Match < ActiveRecord::Base
  include UUID, Trashable
  attr_accessor :groups
  as_enum :type, [:practice, :tournament], prefix: true, map: :string
  as_enum :rule, [:stroke_play, :match_play], prefix: true, map: :string
  belongs_to :owner, class_name: 'User'
  belongs_to :venue
  has_many :players
  scope :by_owner, ->(user) { where(owner_id: user.id) }

  def default_player
    players.first if type_practice?
  end

  def player_by_user user
    players.by_user(user).first if type_tournament?
  end

  class << self
    def create_practice options = {}
      ActiveRecord::Base.transaction do
        raise InvalidGroups.new unless options[:courses].map(&:holes_count).reduce(:+) == 18
        match = create!(owner: options[:owner], venue: options[:courses].first.venue, type: :practice, started_at: Time.now)
        player = match.players.create(user: options[:owner], scoring_type: options[:scoring_type])
        player.create_statistic!
        hole_number = 1
        options[:courses].each_with_index do |course, i|
          course.holes.sort.each do |hole|
            tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
            Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
            hole_number += 1
          end
        end
        match
      end
    end

    def create_tournament options = {}
      ActiveRecord::Base.transaction do
        raise InvalidGroups.new unless options[:courses].map(&:holes_count).reduce(:+) == 18
        match = create!(owner: options[:owner], venue: options[:courses].first.venue, type: :tournament, name: options[:name], password: options[:password], remark: options[:remark], started_at: Time.now)
        player = match.players.create(user: options[:owner], scoring_type: :simple)
        player.create_statistic!
        hole_number = 1
        options[:courses].each_with_index do |course, i|
          course.holes.sort.each do |hole|
            tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
            Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
            hole_number += 1
          end
        end
        match
      end
    end
  end
end
