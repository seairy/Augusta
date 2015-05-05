# -*- encoding : utf-8 -*-
class Province < ActiveRecord::Base
  include UUID
  has_many :cities
  has_many :venues, through: :cities
  scope :alphabetic, -> { all.includes(:venues).sort_by{|province| PinYin.sentence(province.name)} }
end
