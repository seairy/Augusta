# -*- encoding : utf-8 -*-
class Course < ActiveRecord::Base
  include UUID, Trashable
  belongs_to :city
  has_many :groups
  reverse_geocoded_by :latitude, :longitude
  scope :alphabetic, -> { order('CONVERT(courses.name USING GBK) asc') }
  scope :nearest, ->(latitude, longitude) {
    near([latitude, longitude], 5000, unit: :km)
  }
end
