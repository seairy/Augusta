# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  has_many :verification_codes
  has_many :tokens
end
