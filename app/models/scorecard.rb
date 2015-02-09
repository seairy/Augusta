# -*- encoding : utf-8 -*-
class Scorecard < ActiveRecord::Base
  include UUID
  belongs_to :match
  belongs_to :hole
end
