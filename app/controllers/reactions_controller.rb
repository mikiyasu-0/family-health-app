class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @exercise_record = ExerciseRecord.find(params[:exercise_record_id])
    record_user = @exercise_record.user

    if record_user == current_user
      return redirect_to dashboard_path, alert: "この運動記録にはリアクションできません"
    end

    shared_group_exists = current_user.groups
                                      .joins(:users)
                                      .where(users: { id: record_user.id })
                                      .exists?

    unless shared_group_exists
      return redirect_to dashboard_path, alert: "この運動記録にはリアクションできません"
    end

    reaction = current_user.reactions.create(
      exercise_record: @exercise_record,
      reaction_type: params[:reaction_type]
    )

    if reaction.persisted?
      redirect_to dashboard_path, notice: "リアクションしました"
    else
      redirect_to dashboard_path, alert: "リアクションできませんでした"
    end
  end
end
