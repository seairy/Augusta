class Version < ActiveRecord::Base
  include AASM
  mount_uploader :file, FileUploader
  belongs_to :product
  aasm column: 'state' do
    state :pending, initial: true
    state :published
    event :publish do
      transitions from: :pending, to: :published
    end
    event :cancel do
      transitions from: :published, to: :pending
    end
  end
  scope :newly, -> { order(major: :desc).order(minor: :desc).order(point: :desc) }
  scope :available, -> { where(state: 'available') }

  def name
    "#{major}.#{minor}.#{point}"
  end

  class << self
    def named name
      major, minor, point = name.split('.')
      where(major: major).where(minor: minor).where(point: point).first
    end

    def newest
      published.newly.first
    end
  end
end