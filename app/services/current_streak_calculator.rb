require "set"

class CurrentStreakCalculator
  TIME_ZONE = "Tokyo".freeze

  def initialize(user)
    @user = user
  end

  def call
    record_dates = exercise_record_dates
    today = today_in_tokyo
    yesterday = today - 1

    start_date =
      if record_dates.include?(today)
        today
      elsif record_dates.include?(yesterday)
        yesterday
      else
        return 0
      end

    count_streak_from(start_date, record_dates)
  end

  private

  attr_reader :user

  def exercise_record_dates
    user.exercise_records.pluck(:created_at).map do |created_at|
      created_at.in_time_zone(TIME_ZONE).to_date
    end.to_set
  end

  def today_in_tokyo
    Time.current.in_time_zone(TIME_ZONE).to_date
  end

  def count_streak_from(start_date, record_dates)
    streak_count = 0
    current_date = start_date

    while record_dates.include?(current_date)
      streak_count += 1
      current_date -= 1
    end

    streak_count
  end
end
