# -*- encoding : utf-8 -*-
class Token < ActiveRecord::Base
  belongs_to :user
  scope :available, -> { where(available: true) }

  def expired!
    update!(available: false)
  end

  class << self
    def generate! user
      user.tokens.update_all(available: false)
      create!(user: user, content: SecureRandom.urlsafe_base64, generated_at: Time.now)
    end
  end
end
