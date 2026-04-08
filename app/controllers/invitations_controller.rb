class InvitationsController < ApplicationController

  def create
    @group = current_user.groups.find(params[:group_id])

    @invitation = @group.invitations.new(
      invited_by: current_user,
      expires_at: 7.days.from_now
    )

    if @invitation.save
      redirect_to invitation_path(@invitation.token)
    else
      redirect_to group_path(@group), alert: "作成に失敗しました"
    end
  end
end
