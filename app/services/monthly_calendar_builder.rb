class MonthlyCalendarBuilder
  TIME_ZONE = "Tokyo".freeze

  def initialize(user, month: Time.current.in_time_zone(TIME_ZONE).to_date)
    @user = user
    @month = month.to_date.beginning_of_month
  end

  def call
    {
      month: month,
      dates: calendar_dates,
      records_by_date: records_by_date
    }
  end

  private

  attr_reader :user, :month

  def calendar_dates
    dates = (month.beginning_of_month..month.end_of_month).to_a
    start_padding = (month.beginning_of_month.wday + 6) % 7
    end_padding = (7 - ((start_padding + dates.size) % 7)) % 7

    Array.new(start_padding) + dates + Array.new(end_padding)
  end

  def records_by_date
    user.exercise_records
        .where(created_at: month_range)
        .order(created_at: :asc)
        .group_by { |record| record.created_at.in_time_zone(TIME_ZONE).to_date }
  end

  def month_range
    month_start = Time.find_zone!(TIME_ZONE).local(month.year, month.month, 1).beginning_of_day
    month_end = month_start.end_of_month.end_of_day

    month_start..month_end
  end
end
