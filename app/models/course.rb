# -*- encoding : utf-8 -*-
class Course < ActiveRecord::Base
  include UUID
  belongs_to :venue, counter_cache: true
  has_many :holes
end
