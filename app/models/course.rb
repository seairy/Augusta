class Course < ActiveRecord::Base
  include UUID, Trashable
  belongs_to :city
  has_many :groups
  reverse_geocoded_by :latitude, :longitude
  scope :nearest, ->(latitude, longitude) {
    near([latitude, longitude], 5000, unit: :km)
  }
end
