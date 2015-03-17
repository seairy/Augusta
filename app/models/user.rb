# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include UUID, AASM
  as_enum :type, [:guest, :member, :staff, :faker], map: :string
  has_many :verification_codes
  has_many :tokens
  has_many :matches, foreign_key: :owner_id
  aasm column: 'state' do
    state :unactivated, initial: true
    state :activated
    state :prohibited
  end

  def available_token
    tokens.available.first.try(:content)
  end

  class << self
    def sign_up_simple
      ActiveRecord::Base.transaction do
        user = create!(type: :guest, signed_up_at: Time.now)
        user.tokens.generate
        user.update!(nickname: "游客#{user.id}")
        user
      end
    end

    def find_or_create options = {}
      where(phone: options[:phone]).first || create!(phone: options[:phone], type: :member, signed_up_at: Time.now)
    end

    def authorize! token
      Token.available.where(content: token).first.try(:user)
    end
  end
end
