class ExerciseRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise_record, only: %i[edit update]
  before_action :set_user, only: %i[index]
  before_action :authorize_user_access!, only: %i[index]

  def index
    @exercise_records = @user.exercise_records.order(created_at: :desc)

    @records_by_date = @exercise_records
      .group_by { |record| record.created_at.to_date }
      .sort_by { |date, _| date }
      .reverse

    selected_month = selected_calendar_month

    @monthly_calendar = MonthlyCalendarBuilder.new(@user, month: selected_month).call
    @previous_month = @monthly_calendar[:month].prev_month
    @next_month = @monthly_calendar[:month].next_month
    @current_month = current_calendar_month
    @show_next_month_link = @next_month <= @current_month
  end

  def create
    @exercise_record = current_user.exercise_records.new(exercise_record_params)

    if @exercise_record.save
      redirect_to dashboard_path, notice: "運動を記録しました"
    else
      redirect_to dashboard_path, alert: @exercise_record.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    if @exercise_record.update(exercise_record_memo_params)
      redirect_to dashboard_path, notice: "メモを更新しました"
    else
      redirect_to dashboard_path, alert: @exercise_record.errors.full_messages.join(", ")
    end
  end

  private

  def set_exercise_record
    @exercise_record = current_user.exercise_records.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_user_access!
    return if @user == current_user

    shared_group_exists = current_user.groups.joins(:users).where(users: { id: @user.id }).exists?
    return if shared_group_exists

    redirect_to dashboard_path, alert: "このユーザーの運動履歴は閲覧できません"
  end

  def selected_calendar_month
    selected_month =
      if params[:month].present?
        Date.strptime(params[:month], "%Y-%m")
      else
        current_calendar_month
      end

    [selected_month.beginning_of_month, current_calendar_month].min
  rescue Date::Error, ArgumentError
    current_calendar_month
  end

  def current_calendar_month
    Time.current.in_time_zone("Tokyo").to_date.beginning_of_month
  end

  def exercise_record_params
    params.require(:exercise_record).permit(:exercise_type)
  end

  def exercise_record_memo_params
    params.require(:exercise_record).permit(:memo)
  end
end
