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

  class << self
    def sign_up_simple
      user = create!(signed_up_at: Time.now)
      user.tokens.generate
      user.update!(nickname: "临时用户#{user.id}")
      user
    end

    def authorize! token
      Token.available.where(content: token).first.try(:user)
    end
  end
end
