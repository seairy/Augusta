# -*- encoding : utf-8 -*-
class VerificationCode < ActiveRecord::Base
  belongs_to :user
  belongs_to :caddie
  as_enum :type, [:sign_up, :sign_in_simple, :reset_password, :upgrade, :unbind_phone, :rebind_phone], prefix: true, map: :string
  scope :available, -> { where(available: true).where('generated_at > ?', Time.now - 15.minutes) }

  def expired!
    update!(available: false)
  end

  class << self
    def sign_up options = {}
      user = User.find_or_create(phone: options[:phone])
      raise FrequentRequest.new if Time.now - (user.verification_codes.type_sign_ups.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if user.verification_codes.where('generated_at >= ?', Time.now.beginning_of_day).where('generated_at <= ?', Time.now.end_of_day).count >= 15
      raise DuplicatedPhone.new if user.activated?
      user.verification_codes.type_sign_ups.update_all(available: false)
      user.verification_codes.generate_and_send(phone: options[:phone], type: :sign_up)
    end

    def sign_in_simple options = {}
      user = User.where(phone: options[:phone]).first
      raise PhoneNotFound.new unless user
      raise FrequentRequest.new if Time.now - (user.verification_codes.type_sign_in_simples.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if user.verification_codes.where('generated_at >= ?', Time.now.beginning_of_day).where('generated_at <= ?', Time.now.end_of_day).count >= 15
      raise InvalidUserType.new unless user.member?
      user.verification_codes.type_sign_in_simples.update_all(available: false)
      user.verification_codes.generate_and_send(phone: options[:phone], type: :sign_in_simple)
    end

    def upgrade options = {}
      raise FrequentRequest.new if Time.now - (options[:user].verification_codes.type_upgrades.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if options[:user].verification_codes.where('generated_at >= ?', Time.now.beginning_of_day).where('generated_at <= ?', Time.now.end_of_day).count >= 15
      raise InvalidUserType.new unless options[:user].guest?
      raise DuplicatedPhone.new if User.where(phone: options[:phone]).first
      options[:user].verification_codes.type_upgrades.update_all(available: false)
      options[:user].verification_codes.generate_and_send(phone: options[:phone], type: :upgrade)
    end

    def reset_password options = {}
      user = User.where(phone: options[:phone]).first
      raise PhoneNotFound.new unless user
      raise FrequentRequest.new if Time.now - (user.verification_codes.type_reset_passwords.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if user.verification_codes.where('generated_at >= ?', Time.now.beginning_of_day).where('generated_at <= ?', Time.now.end_of_day).count >= 15
      raise InvalidUserType.new unless user.member?
      user.verification_codes.type_reset_passwords.update_all(available: false)
      user.verification_codes.generate_and_send(phone: options[:phone], type: :reset_password)
    end

    def unbind_phone options = {}
      raise FrequentRequest.new if Time.now - (options[:user].verification_codes.type_unbind_phones.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if options[:user].verification_codes.where('generated_at >= ?', Time.now.beginning_of_day).where('generated_at <= ?', Time.now.end_of_day).count >= 15
      raise InvalidUserType.new unless options[:user].member?
      raise DuplicatedPhone.new if User.where(phone: options[:phone]).first
      options[:user].verification_codes.type_update_phones.update_all(available: false)
      options[:user].verification_codes.generate_and_send(phone: options[:phone], type: :update_phone)
    end

    def caddie_sign_up options = {}
      raise FrequentRequest.new if Time.now - (options[:caddie].verification_codes.type_sign_ups.order(generated_at: :desc).first.try(:generated_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if options[:caddie].verification_codes.where('generated_at >= ?', Time.now.beginning_of_day).where('generated_at <= ?', Time.now.end_of_day).count >= 10
      raise DuplicatedPhone.new if options[:caddie].activated?
      options[:caddie].verification_codes.type_sign_ups.update_all(available: false)
      options[:caddie].verification_codes.generate_and_send(phone: options[:phone], type: :sign_up)
    end

    def generate_and_send options = {}
      verification_code = create!(content: rand(1234..9876), type: options[:type], generated_at: Time.now)
      uri = URI.parse('https://sms-api.luosimao.com/v1/send.json')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth 'api', "key-#{Setting.key[:luosimao_sms][:api_key]}"
      request.set_form_data(mobile: options[:phone], message: "您的验证码为#{verification_code.content}，请于15分钟内使用。【我爱高尔夫】")
      http.request(request) if Rails.env == 'production'
    end
  end
end
