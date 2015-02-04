class Hole < ActiveRecord::Base
  include UUID
  belongs_to :group, counter_cache: true
  has_many :tee_boxes
end
