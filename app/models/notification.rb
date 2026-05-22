class Notification < ApplicationRecord
  NOTIFICATION_TYPES = %w[reaction].freeze

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :notification_type, presence: true, inclusion: { in: NOTIFICATION_TYPES }

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  def unread?
    read_at.nil?
  end

  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current)
  end
end
