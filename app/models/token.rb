# -*- encoding : utf-8 -*-
class Token < ActiveRecord::Base
  belongs_to :user
  scope :available, -> { where(available: true) }

  class << self
    def generate
      create!(content: SecureRandom.urlsafe_base64, generated_at: Time.now)
    end
  end
end
