class Reaction < ApplicationRecord
  REACTION_TYPES = ["like", "clap", "cheer"].freeze
  REACTION_EMOJIS = { "like" => "👍", "clap" => "👏", "cheer" => "💪" }.freeze
  belongs_to :user
  belongs_to :exercise_record

  validates :reaction_type, presence: true, inclusion: { in: REACTION_TYPES }
  validates :reaction_type, uniqueness: { scope: [ :user_id, :exercise_record_id ] }

  def emoji
    REACTION_EMOJIS[reaction_type]
  end
  end
