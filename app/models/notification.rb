class Notification < ActiveRecord::Base
  scope :by_administrator, ->(administrator_id) { where(administrator_id: administrator_id) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :sorted, -> { order(read: :asc, created_at: :desc) }
end
