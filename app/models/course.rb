class Course < ActiveRecord::Base
  include UUID, Trashable
  belongs_to :city
  has_many :groups
end
