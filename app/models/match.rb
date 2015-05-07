# -*- encoding : utf-8 -*-
class Match < ActiveRecord::Base
  include UUID, Trashable, AASM
  attr_accessor :groups
  as_enum :type, [:practice, :tournament], prefix: true, map: :string
  as_enum :rule, [:stroke_play, :match_play], prefix: true, map: :string
  belongs_to :owner, class_name: 'User'
  belongs_to :venue
  has_many :players
  aasm column: 'state' do
    state :progressing, initial: true
    state :finished
    event :finish do
      transitions from: :progressing, to: :finished
    end
  end
  default_scope { includes(:venue) }
  scope :by_owner, ->(user) { where(owner_id: user.id) }
  scope :latest, -> { order(started_at: :desc) }
  scope :participated, ->(user) { joins(:players).where(players: { user_id: user.id }) }

  def default_player
    players.first if type_practice?
  end

  def owned_player
    players.where(user_id: owner_id).first
  end

  def player_by_user user
    players.by_user(user).first
  end

  def courses
    owned_player.scorecards.where(number: [1, 10]).map{|scorecard| scorecard.hole.course}.instance_eval{ map(&:holes_count).reduce(:+) == 36 ? uniq : self }
  end

  def participate options = {}
    ActiveRecord::Base.transaction do
      raise InvalidMatchType.new unless type_tournament?
      raise InvalidPassword.new unless password == options[:password]
      raise DuplicatedParticipant.new if players.map(&:user_id).include?(options[:user].id)
      raise InvalidState.new if finished?
      player = players.create(user: options[:user], scoring_type: :simple)
      player.create_statistic!
      hole_number = 1
      courses.each_with_index do |course, i|
        course.holes.sort.each do |hole|
          tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
          Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
          hole_number += 1
        end
      end
    end
  end

  def participated? user
    players.map(&:user_id).include?(user.id)
  end

  class << self
    def create_with_player options = {}
      ActiveRecord::Base.transaction do
        raise InvalidGroups.new unless options[:courses].map(&:holes_count).reduce(:+) == 18
        # ** DEPRECATED **
        match = create!(owner: options[:owner], venue: options[:courses].first.venue, type: :tournament, started_at: Time.now)
        player = match.players.create(user: options[:owner], scoring_type: options[:scoring_type])
        hole_number = 1
        options[:courses].each_with_index do |course, i|
          course.holes.sort.each do |hole|
            tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
            Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
            hole_number += 1
          end
        end
        player.create_statistic!
        match
      end
    end

    # ** DEPRECATED **
    def create_practice options = {}
      ActiveRecord::Base.transaction do
        raise InvalidGroups.new unless options[:courses].map(&:holes_count).reduce(:+) == 18
        match = create!(owner: options[:owner], venue: options[:courses].first.venue, type: :practice, started_at: Time.now)
        player = match.players.create(user: options[:owner], scoring_type: options[:scoring_type])
        hole_number = 1
        options[:courses].each_with_index do |course, i|
          course.holes.sort.each do |hole|
            tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
            Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
            hole_number += 1
          end
        end
        player.create_statistic!
        match
      end
    end

    # ** DEPRECATED **
    def create_tournament options = {}
      ActiveRecord::Base.transaction do
        raise InvalidGroups.new unless options[:courses].map(&:holes_count).reduce(:+) == 18
        match = create!(owner: options[:owner], venue: options[:courses].first.venue, type: :tournament, name: options[:name], password: options[:password], rule: options[:rule], remark: options[:remark], started_at: Time.now)
        player = match.players.create(user: options[:owner], scoring_type: :simple)
        hole_number = 1
        options[:courses].each_with_index do |course, i|
          course.holes.sort.each do |hole|
            tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
            Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
            hole_number += 1
          end
        end
        player.create_statistic!
        match
      end
    end
  end
end
