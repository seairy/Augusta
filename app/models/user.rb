# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include UUID, AASM
  has_many :verification_codes
  has_many :tokens
  aasm column: 'state' do
    state :temporary, initial: true
    state :verified
    state :prohibited
  end

  def temporary?
    phone.blank?
  end

  def available_token
    tokens
  end

  class << self
    def sign_up_simple
      create!(signed_up_at: Time.now)
    end
  end
end
