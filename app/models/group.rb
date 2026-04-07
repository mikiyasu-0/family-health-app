class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  has_many :invitations, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
