# -*- encoding : utf-8 -*-
class VerificationCode < ActiveRecord::Base
  belongs_to :user
  scope :available, -> { where(available: true) }

  class << self
    def generate_and_send options = {}
      user = User.find_or_create(phone: options[:phone])
      verification_code = user.verification_codes.create!(content: rand(1234..9876), generated_at: Time.now)
      # send sms
    end
  end
end
