# -*- encoding : utf-8 -*-
class Venue < ActiveRecord::Base
  include UUID, Trashable
  attr_accessor :visited_count
  attr_accessor :played_count
  belongs_to :city
  has_many :courses
  has_many :matches
  reverse_geocoded_by :latitude, :longitude
  scope :alphabetic, -> { order('CONVERT(venues.name USING GBK) asc') }
  scope :nearest, ->(latitude, longitude) {
    near([latitude, longitude], 5000, unit: :km)
  }
  scope :played_by_user, ->(user) { includes(:players).where(players: { user_id: user.id }) }
  validates :city_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :address, length: { maximum: 500 }
  validates :description, length: { maximum: 30000 }

  def holes_count
    courses.map(&:holes_count).reduce(:+)
  end
end
