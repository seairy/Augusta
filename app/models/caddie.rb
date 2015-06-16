class Caddie < ActiveRecord::Base
  include UUID, AASM
  has_many :verification_codes
  aasm column: 'state' do
    state :unactivated, initial: true
    state :activated
    state :prohibited
    event :active do
      transitions from: :unactivated, to: :activated
    end
  end

  class << self
    def sign_up options = {}
      ActiveRecord::Base.transaction do
        caddie = where(phone: options[:phone]).first || raise(PhoneNotFound.new)
        raise DuplicatedPhone.new if !caddie.unactivated?
        caddie.verification_codes.available.type_caddie_sign_ups.first.tap do |verification_code|
          raise InvalidVerificationCode.new unless verification_code
          if Rails.env == 'development'
            raise InvalidVerificationCode.new if options[:verification_code] != '8888'
          else
            raise InvalidVerificationCode.new if options[:verification_code] != verification_code.content
          end
          verification_code.expired!
        end
        caddie.active!
        caddie.update!(hashed_password: Digest::MD5.hexdigest(options[:password]))
        caddie
      end
    end

    def sign_in options = {}
      ActiveRecord::Base.transaction do
        caddie = where(phone: options[:phone]).first || raise(PhoneNotFound.new)
        raise InvalidStatus.new unless caddie.activated?
        raise InvalidPassword.new unless caddie.hashed_password == Digest::MD5.hexdigest(options[:password])
        caddie.update!(last_signined_at: administrator.current_signined_at, current_signined_at: Time.now)
        caddie
      end
    end

    def find_or_create options = {}
      where(phone: options[:phone]).first || create!(phone: options[:phone], signed_up_at: Time.now)
    end
  end
end
