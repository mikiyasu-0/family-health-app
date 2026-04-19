class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :exercise_record

  validates :reaction_type, presence: true
  validates :reaction_type, uniqueness: { scope: [:user_id, :exercise_record_id] }
end
