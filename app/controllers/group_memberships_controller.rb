class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invitation, only: %i[accept]
  before_action :validate_invitation!, only: %i[accept]

  def accept
    group = @invitation.group

    if current_user.groups.exists?(group.id)
      redirect_to group_path(group), notice: "すでにグループに所属しています"
      return
    end

    ActiveRecord::Base.transaction do
      # GroupMembershipを作成して参加
      GroupMembership.create!(
        user: current_user,
        group: group
      )

      # 招待の更新
      @invitation.update!(
        status: :accepted,
        used_by: current_user,
        accepted_at: Time.current
      )
    end

    # 招待tokenは使用後消す
    session.delete(:invitation_token)

    redirect_to group_path(group), notice: "グループに参加しました"
  end

  def destroy
    @group = current_user.groups.find(params[:group_id])
    membership = @group.group_memberships.find_by(user: current_user)

    if membership.nil?
      redirect_to dashboard_path, alert: "このグループには所属していません"
    elsif @group.users.count == 1
      redirect_to group_path(@group), alert: "最後の1人なので退会できません"
    elsif membership.admin? && @group.group_memberships.admin.count == 1
      redirect_to group_path(@group), alert: "最後のadminなので退会できません"
    else
      membership.destroy!
      redirect_to dashboard_path, notice: "グループを退会しました"
    end
  end

  private

  def set_invitation
    token = session[:invitation_token]
    @invitation = Invitation.find_by(token: token)
  end

  def validate_invitation!
    if @invitation.nil?
      redirect_to root_path, alert: "無効な招待リンクです"
    elsif @invitation.expired?
      redirect_to root_path, alert: "招待リンクの期限が切れています"
    elsif @invitation.accepted?
      redirect_to root_path, alert: "この招待リンクはすでに使用されています"
    end
  end
end
