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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 30 }
end
