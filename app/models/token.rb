# -*- encoding : utf-8 -*-
class Token < ActiveRecord::Base
  belongs_to :user
  scope :available, -> { where(available: true) }
end
