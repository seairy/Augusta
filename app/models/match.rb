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
      raise DuplicatedParticipant.new if participated?(options[:user])
      raise InvalidMatchState.new if finished?
      player = players.create(user: options[:user], scoring_type: options[:scoring_type])
      hole_number = 1
      courses.each_with_index do |course, i|
        course.holes.sort.each do |hole|
          tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
          Scorecard.create!(player: player, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
          hole_number += 1
        end
      end
      player.create_statistic!
    end
  end

  def participated? user
    players.map(&:user_id).include?(user.id)
  end

  def generate_password
    raise InvalidMatchState.new if finished?
    Match.clean_expired_password!
    reload
    exist_passwords = Match.where.not(password: nil).pluck(:password)
    raise NotEnoughPassword.new if exist_passwords.count > 2000
    if password
      password
    else
      new_password = nil
      loop do 
        new_password = rand(9999).to_s.rjust(4, '0')
        break if !exist_passwords.include?(new_password) and new_password.split('').uniq.count > 2
      end
      update!(password: new_password, password_expired_at: Time.now + 2.hours)
      new_password
    end
  end

  def calculate_leaderboard!
    players = self.players.started.ranked.latest.to_a
    players.length.times do |i|
      if i.zero?
        if players.length > 1 and players[i].total == players[i + 1].total
          players[i].update!(position: 'T1')
        else
          players[i].update!(position: i + 1)
        end
      elsif i == players.length - 1
        if players[i].total == players[i - 1].total
          players[i].update!(position: players[i - 1].position)
        else
          players[i].update!(position: i + 1)
        end
      else
        if players[i].total == players[i - 1].total
          players[i].update!(position: players[i - 1].position)
        else
          if players[i].total == players[i + 1].total
            players[i].update!(position: "T#{i + 1}")
          else
            players[i].update!(position: i + 1)
          end
        end
      end
    end
  end

  class << self
    def clean_expired_password!
      where('password_expired_at < ?', Time.now).update_all(password: nil, password_expired_at: nil)
    end

    def verify password
      where(password: password).where('password_expired_at >= ?', Time.now).first || raise(InvalidPassword)
    end

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
  end
end