class LongestStreakCalculator
  TIME_ZONE = "Tokyo".freeze

  def initialize(user)
    @user = user
  end

  def call
    record_dates = exercise_record_dates

    return 0 if record_dates.empty?

    longest_streak = 1
    current_streak = 1
    previous_date = record_dates.first

    record_dates.drop(1).each do |current_date|
      if current_date == previous_date + 1
        current_streak += 1
      else
        current_streak = 1
      end

      longest_streak = [longest_streak, current_streak].max
      previous_date = current_date
    end

    longest_streak
  end

  private

  attr_reader :user

  def exercise_record_dates
    user.exercise_records.pluck(:created_at).map do |created_at|
      created_at.in_time_zone(TIME_ZONE).to_date
    end.uniq.sort
  end
end
