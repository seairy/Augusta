class Match < ActiveRecord::Base
  include UUID
  attr_accessor :groups
  as_enum :type, [:practice], prefix: true, map: :string
  belongs_to :owner, class_name: 'User'
  belongs_to :course
  has_many :scorecards

  class << self
    def create_practice! options = {}
      match = create!(owner: options[:owner], course: options[:groups].first.course, type: :practice)
      holes = options[:groups].map{|group| group.holes.map{|hole| { id: hole.id, name: "#{group.name}#{hole.name}"}}}.flatten
      holes *= 2 if holes.length == 9
      puts "***** #{holes}"

    end
  end
end
