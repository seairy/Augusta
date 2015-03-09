# -*- encoding : utf-8 -*-
class Match < ActiveRecord::Base
  include UUID, Trashable
  attr_accessor :groups
  as_enum :type, [:practice], prefix: true, map: :string
  belongs_to :owner, class_name: 'User'
  belongs_to :course
  has_one :statistic
  has_many :scorecards, -> { order(:number) }
  scope :by_owner, ->(user) { where(owner_id: user.id) }

  def score
    scorecards.map(&:score).compact.reduce(:+) || 0
  end

  def recorded_scorecards_count
    scorecards.select{|s| s.score}.count
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
    scorecards.map(&:score).compact.reduce(:+)
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

  end

  def penalties

  end

  class << self
    def create_practice options = {}
      ActiveRecord::Base.transaction do
        raise InvalidGroups.new unless options[:groups].map(&:holes_count).reduce(:+) == 18
        match = create!(owner: options[:owner], course: options[:groups].first.course, type: :practice, started_at: Time.now)
        match.create_statistic!
        hole_number = 1
        options[:groups].each_with_index do |group, i|
          group.holes.order(:name).each do |hole|
            tee_box = hole.tee_boxes.send(options[:tee_boxes][i])
            Scorecard.create!(match: match, hole: hole, number: hole_number, par: hole.par, tee_box_color: tee_box.color, distance_from_hole_to_tee_box: tee_box.distance_from_hole)
            hole_number += 1
          end
        end
        match
      end
    end
  end
end
