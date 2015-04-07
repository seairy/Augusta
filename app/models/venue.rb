# -*- encoding : utf-8 -*-
class Venue < ActiveRecord::Base
  include UUID, Trashable
  belongs_to :city
  has_many :courses
  reverse_geocoded_by :latitude, :longitude
  scope :alphabetic, -> { order('CONVERT(venues.name USING GBK) asc') }
  scope :nearest, ->(latitude, longitude) {
    near([latitude, longitude], 5000, unit: :km)
  }
  validates :city_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :address, length: { maximum: 500 }
  validates :description, length: { maximum: 30000 }
end
