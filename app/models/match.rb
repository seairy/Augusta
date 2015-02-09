# -*- encoding : utf-8 -*-
class Match < ActiveRecord::Base
  include UUID
  attr_accessor :groups
  as_enum :type, [:practice], prefix: true, map: :string
  belongs_to :owner, class_name: 'User'
  belongs_to :course
  has_many :scorecards
  scope :by_owner, ->(user) { where(owner_id: user.id) }

  class << self
    def create_practice! options = {}
      ActiveRecord::Base.transaction do
        match = create!(owner: options[:owner], course: options[:groups].first.course, type: :practice)
        holes = options[:groups].map{|group| group.holes}.flatten
        holes *= 2 if holes.length == 9
        holes.each_with_index{|hole, i| Scorecard.create!(match: match, hole: hole, number: i + 1, par: hole.par)}
        match
      end
    end
  end
end
