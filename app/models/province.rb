# -*- encoding : utf-8 -*-
class Province < ActiveRecord::Base
  include UUID
  has_many :cities
  has_many :courses, through: :cities
  scope :alphabetic, -> { order('CONVERT(provinces.name USING GBK) asc') }
end
