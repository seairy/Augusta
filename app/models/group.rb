# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  include UUID
  belongs_to :course, counter_cache: true
  has_many :holes
end
