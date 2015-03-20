# -*- encoding : utf-8 -*-
class Hole < ActiveRecord::Base
  include UUID
  belongs_to :course, counter_cache: true
  has_many :tee_boxes
end
