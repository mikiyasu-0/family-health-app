class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @exercise_types = ExerciseRecord::EXERCISE_TYPES
    @today_exercise_records = current_user.exercise_records.where(
      created_at: Time.current.beginning_of_day..Time.current.end_of_day
    )
  end
end
