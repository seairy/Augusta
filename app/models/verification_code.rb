# -*- encoding : utf-8 -*-
class VerificationCode < ActiveRecord::Base
  belongs_to :user
  as_enum :type, [:sign_up, :forgot_password, :upgrade], prefix: true, map: :string
  scope :available, -> { where(available: true) }

  def expired!
    update!(available: false)
  end

  class << self
    def generate_and_send options = {}
      user = User.find_or_create(phone: options[:phone])
      raise FrequentRequest.new if Time.now - (user.verification_codes.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise DuplicatedPhone.new if user.activated? and options[:type] == 'sign_up'
      user.verification_codes.update_all(available: false)
      verification_code = user.verification_codes.create!(content: rand(1234..9876), type: options[:type], generated_at: Time.now)
      # send sms
    end
  end
end
