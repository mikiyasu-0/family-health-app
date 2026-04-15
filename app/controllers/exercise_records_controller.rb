class ExerciseRecordsController < ApplicationController
  before_action :authenticate_user!

  def create
    @exercise_record = current_user.exercise_records.new(exercise_record_params)

    if @exercise_record.save
      redirect_to dashboard_path, notice: "運動を記録しました"
    else
      redirect_to dashboard_path, alert: @exercise_record.errors.full_message.join(", ")
    end
  end

  private

  def exercise_record_params
    params.require(:exercise_record).permit(:exercise_type)
  end
end
