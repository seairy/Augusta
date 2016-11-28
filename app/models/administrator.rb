# -*- encoding : utf-8 -*-
class Administrator < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  has_many :notifications
  before_create :hash_password_and_set_token
  validates :account, presence: true, length: { maximum: 32 }
  validates :password, presence: true, length: { maximum: 16 }, on: :create
  validates :name, presence: true, length: { maximum: 50 }

  def authenticate password
    self.hashed_password == Digest::MD5.hexdigest(password) ? self : nil
  end

  def update_password password
    self.update(hashed_password: Digest::MD5.hexdigest(password))
  end

  protected
    def hash_password_and_set_token
      self.hashed_password = Digest::MD5.hexdigest self.password
      self.token = SecureRandom.urlsafe_base64
    end
end
