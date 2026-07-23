class Reaction < ApplicationRecord
  REACTION_TYPES = [ "like", "clap", "cheer" ].freeze

  belongs_to :user
  belongs_to :exercise_record
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :reaction_type, presence: true, inclusion: { in: REACTION_TYPES }
  validates :reaction_type, uniqueness: { scope: [ :user_id, :exercise_record_id ] }
end
