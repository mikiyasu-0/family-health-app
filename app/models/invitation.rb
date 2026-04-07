class Invitation < ApplicationRecord
  belongs_to :group
  belongs_to :invited_by, class_name: "User"
  belongs_to :used_by, class_name: "User", optional: true

  enum status: { pending: 0, accepted: 1 }
  has_secure_token :token

  validates :expires_at, presence: true
  validates :token, presence: true

  def expired?
    expires_at < Time.current
  end

  def usable?
    pending? && !expired? && used_by.nil?
  end
end
