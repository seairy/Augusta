# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include UUID, AASM
  as_enum :type, [:guest, :member, :staff, :faker], map: :string
  mount_uploader :portrait, UserPortraitUploader
  has_many :verification_codes
  has_many :tokens
  has_many :matches, foreign_key: :owner_id
  has_many :players
  aasm column: 'state' do
    state :unactivated, initial: true
    state :activated
    state :prohibited
    event :active do
      transitions from: :unactivated, to: :activated
    end
  end
  scope :recently, ->(days) { where('signed_up_at >= ?', (Time.now - days).beginning_of_day) }
  validates :nickname, length: { maximum: 20 }

  def available_token
    tokens.available.first.try(:content)
  end

  def update_password options = {}
    raise InvalidOriginalPassword.new unless Digest::MD5.hexdigest(options[:original_password]) == hashed_password
    update(hashed_password: Digest::MD5.hexdigest(options[:password]))
  end

  def update_birthday birthday
    update(birthday: Time.at(birthday))
  end

  def sign_out options = {}
    tokens.available.first.try(:expired!)
  end

  def visited_venues
    venues = players.includes(:match).inject(Hash.new(0)){|result, player| result[player.match.venue_id] += 1; result}
    Venue.find(venues.keys).map{|venue| venue.visited_count = venues[venue.id]; venue}
  end

  def played_venues
    venues = players.includes(:match).inject(Hash.new(0)){|result, player| result[player.match.venue_id] += 1; result}
    Venue.find(venues.keys).map{|venue| venue.played_count = venues[venue.id]; venue}
  end

  def upgrade options = {}
    ActiveRecord::Base.transaction do
      raise InvalidUserType.new unless options[:user].guest?
      options[:user].verification_codes.available.type_upgrades.first.tap do |verification_code|
        raise InvalidVerificationCode.new unless verification_code
        if Rails.env == 'development'
          raise InvalidVerificationCode.new if options[:verification_code] != '8888'
        else
          raise InvalidVerificationCode.new if options[:verification_code] != verification_code.content
        end
        verification_code.expired!
      end
      options[:user].update!(type_cd: :member, phone: options[:phone], nickname: "会员#{options[:user].id}", hashed_password: Digest::MD5.hexdigest(options[:password]))
      options[:user].active!
    end
  end

  class << self
    def sign_up_simple
      ActiveRecord::Base.transaction do
        user = create!(type: :guest, signed_up_at: Time.now)
        user.update!(nickname: "游客#{user.id}")
        Token.generate!(user)
        user
      end
    end

    def sign_up options = {}
      ActiveRecord::Base.transaction do
        user = where(phone: options[:phone]).first || raise(PhoneNotFound.new)
        raise DuplicatedPhone.new if !user.unactivated? or !user.member?
        user.verification_codes.available.type_sign_ups.first.tap do |verification_code|
          raise InvalidVerificationCode.new unless verification_code
          if Rails.env == 'development'
            raise InvalidVerificationCode.new if options[:verification_code] != '8888'
          else
            raise InvalidVerificationCode.new if options[:verification_code] != verification_code.content
          end
          verification_code.expired!
        end
        Token.generate!(user)
        user.active!
        user.update!(nickname: "会员#{user.id}", hashed_password: Digest::MD5.hexdigest(options[:password]))
        user
      end
    end

    def sign_in options = {}
      ActiveRecord::Base.transaction do
        user = where(phone: options[:phone]).first || raise(PhoneNotFound.new)
        raise InvalidStatus.new unless user.activated?
        raise InvalidPassword.new unless user.hashed_password == Digest::MD5.hexdigest(options[:password])
        Token.generate!(user)
        user
      end
    end

    def sign_in_simple options = {}
      ActiveRecord::Base.transaction do
        user = where(phone: options[:phone]).first || raise(PhoneNotFound.new)
        raise InvalidStatus.new unless user.activated?
        user.verification_codes.available.type_sign_in_simples.first.tap do |verification_code|
          raise InvalidVerificationCode.new unless verification_code
          if Rails.env == 'development'
            raise InvalidVerificationCode.new if options[:verification_code] != '8888'
          else
            raise InvalidVerificationCode.new if options[:verification_code] != verification_code.content
          end
          verification_code.expired!
        end
        Token.generate!(user)
        user
      end
    end

    def reset_password options = {}
      user = User.where(phone: options[:phone]).first
      raise PhoneNotFound.new unless user
      raise InvalidUserType.new unless user.member?
      user.verification_codes.available.type_reset_passwords.first.tap do |verification_code|
        raise InvalidVerificationCode.new unless verification_code
        if Rails.env == 'development'
          raise InvalidVerificationCode.new if options[:verification_code] != '8888'
        else
          raise InvalidVerificationCode.new if options[:verification_code] != verification_code.content
        end
        verification_code.expired!
      end
      user.update!(hashed_password: Digest::MD5.hexdigest(options[:password]))
    end

    def find_or_create options = {}
      where(phone: options[:phone]).first || create!(phone: options[:phone], type: :member, signed_up_at: Time.now)
    end

    def authorize! token
      Token.available.where(content: token).first.try(:user)
    end
  end
end