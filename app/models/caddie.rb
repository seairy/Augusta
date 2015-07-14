class Caddie < ActiveRecord::Base
  include UUID, AASM
  has_many :verification_codes
  has_many :players
  aasm column: 'state' do
    state :activated, initial: true
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
      caddie = where(open_id: options[:open_id]).first
      caddie.update!(last_signined_at: administrator.current_signined_at, current_signined_at: Time.now)
      caddie
    end

    def find_or_create open_id
      where(open_id: open_id).first || create!(open_id: open_id, signed_up_at: Time.now)
    end

    def scoring_for_player options = {}
      caddie = self.find_or_create(open_id: options[:open_id])
      player = Player.where(invite_caddie_ticket: options[:ticket]).first
      player.update!(caddie_id: caddie.id) if player and player.caddie.nil?
    end
  end
end
