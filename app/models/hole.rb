class Hole < ActiveRecord::Base
  include UUID
  belongs_to :group
  has_many :tee_boxes
end
