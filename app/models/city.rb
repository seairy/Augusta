# -*- encoding : utf-8 -*-
class City < ActiveRecord::Base
  include UUID
  belongs_to :province
  has_many :courses
end
