class ExerciseRecord < ApplicationRecord
  belongs_to :user

  EXERCISE_TYPES = %w[walk chair_squat heel_raise rest].freeze

  validates :exercise_type, presence: true, inclusion: { in: EXERCISE_TYPES }
  validates :memo, length: { maximum: 100 }
  validate :one_record_per_day, on: :create

  private

  def one_record_per_day
    return if user_id.blank? || exercise_type.blank?

    today_range = Time.current.beginning_of_day..Time.current.end_of_day

    existing_record = ExerciseRecord
      .where(user_id: user_id)
      .where(exercise_type: exercise_type)
      .where(created_at: today_range)

    if existing_record.exists?
      errors.add(:exercise_type, "は1日1回まで記録できます")
    end
  end
end
