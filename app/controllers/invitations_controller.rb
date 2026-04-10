class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_invitation, only: %i[show share]
  before_action :validate_invitation!, only: %i[show share]

  def create
    @group = current_user.groups.find(params[:group_id])

    @invitation = @group.invitations.new(
      invited_by: current_user,
      expires_at: 7.days.from_now
    )

    if @invitation.save
      redirect_to share_invitation_path(@invitation.token)
    else
      redirect_to group_path(@group), alert: "作成に失敗しました"
    end
  end

  def show
    session[:invitation_token] = @invitation.token
  end

  def share
    @invite_url = "#{request.base_url}#{invitation_path(@invitation.token)}"
  end

  private

  def set_invitation
    @invitation = Invitation.find_by(token: params[:token])
  end

  def validate_invitation!
    if @invitation.nil?
      redirect_to root_path, alert: "無効な招待リンクです"
      return
    elsif @invitation.expired?
      redirect_to root_path, alert: "招待リンクの期限が切れています"
      return
    elsif @invitation.accepted?
      redirect_to root_path, alert: "この招待リンクはすでに使用されています"
      return
    end
  end
end
