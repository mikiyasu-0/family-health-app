class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_streak = CurrentStreakCalculator.new(current_user).call
    @longest_streak = LongestStreakCalculator.new(current_user).call
    @streak_badge = StreakBadgeSelector.new(@current_streak).call
    @weekly_summary = WeeklySummaryCalculator.new(current_user).call
    @body_memo = BodyMemoGenerator.new(user: current_user).call

    today_range = Time.current.beginning_of_day..Time.current.end_of_day

    @exercise_types = ExerciseRecord::EXERCISE_TYPES
    @today_exercise_records = current_user.exercise_records
                                          .where(created_at: today_range)
                                          .includes(:reactions, comments: :user)

    @group_members = current_user.groups.includes(:users).flat_map(&:users).uniq
    @group_members = @group_members.reject { |user| user == current_user }

    @group_members_today_records = ExerciseRecord
      .where(user: @group_members, created_at: today_range)
      .includes(:user, :reactions, comments: :user)

    @records_by_user = @group_members_today_records.group_by(&:user_id)
  end
end
