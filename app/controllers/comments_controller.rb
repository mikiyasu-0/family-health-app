class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise_record
  before_action :authorize_comment!

  def create
    @comment = @exercise_record.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: dashboard_path, notice: "コメントを投稿しました"
    else
      redirect_back fallback_location: dashboard_path, alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def set_exercise_record
    @exercise_record = ExerciseRecord.find(params[:exercise_record_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_comment!
    return if @exercise_record.user == current_user
    return if same_group_user?

    redirect_back fallback_location: dashboard_path, alert: "この記録にはコメントできません"
  end

  def same_group_user?
    current_user.groups.exists?(id: @exercise_record.user.groups.select(:id))
  end
end

