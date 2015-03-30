# -*- encoding : utf-8 -*-
class Course < ActiveRecord::Base
  include UUID
  belongs_to :venue, counter_cache: true
  has_many :holes

  def create_holes_and_tee_boxes!
    (1..holes_count).each do |index|
      holes = self.holes.create!(name: index, par: 9)
      [:red, :white, :blue, :black, :gold].each do |tee_box_color|
        holes.tee_boxes.create!(color: tee_box_color, distance_from_hole: 999)
      end
    end
  end
end
