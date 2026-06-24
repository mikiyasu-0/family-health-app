class WeeklySummaryCalculator
  TIME_ZONE = "Tokyo".freeze

  def initialize(user)
    @user = user
  end

  def call
    records = weekly_records

    {
      recorded_days_count: recorded_days_count(records),
      exercise_counts: exercise_counts(records),
      has_records: records.exists?
    }
  end

  private

  attr_reader :user

  def weekly_records
    user.exercise_records.where(created_at: week_range)
  end

  def week_range
    today = Time.current.in_time_zone(TIME_ZONE)

    today.beginning_of_week(:monday)..today.end_of_week(:monday)
  end

  def recorded_days_count(records)
    records.pluck(:created_at).map do |created_at|
      created_at.in_time_zone(TIME_ZONE).to_date
    end.uniq.count
  end

  def exercise_counts(records)
    default_counts.merge(records.group(:exercise_type).count)
  end

  def default_counts
    ExerciseRecord::EXERCISE_TYPES.index_with(0)
  end
end
