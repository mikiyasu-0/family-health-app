class User < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :sent_invitations,
           class_name: "Invitation",
           foreign_key: :invited_by_id,
           dependent: :destroy,
           inverse_of: :invited_by
  has_many :used_invitations,
           class_name: "Invitation",
           foreign_key: :used_by_id,
           dependent: :nullify,
           inverse_of: :used_by
  has_many :exercise_records, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :body_memos, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  validates :name, presence: true, length: { maximum: 30 }

  def self.from_omniauth(auth)
    return nil if auth.provider == "google_oauth2" && !auth.info.email_verified
    return nil if auth.info.email.blank?

    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    return nil if exists?(email: auth.info.email)

    create do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.email = auth.info.email
      u.name = auth.info.name.presence || auth.info.email.split("@").first
      u.password = SecureRandom.hex(16)
    end
  end

  def password_required?
    super && provider.blank?
  end

  def password_changeable?
    provider.blank?
  end
end
