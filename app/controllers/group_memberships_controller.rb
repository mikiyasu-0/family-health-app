class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!

  def accept
    token = session[:invitation_token]
    invitation = Invitation.find_by(token: token)

    if invitation.nil?
      redirect_to root_path, alert: "無効な招待です。"
      return
    end

    unless invitation.usable?
      redirect_to root_path, alert: "この招待は使用できません"
      return
    end

    group = invitation.group

    if current_user.groups.exists?(group.id)
      redirect_to group_path(group), notice: "すでにグループに所属しています"
      return
    end

    ActiveRecord::Base.transaction do
      #GroupMembershipを作成して参加
      GroupMembership.create!(
        user: current_user,
        group: group
      )

      #招待の更新
      invitation.update!(
        status: :accepted,
        used_by: current_user,
        accepted_at: Time.current
      )
    end

    #招待tokenは使用後消す
    session.delete(:invitation_token)

    redirect_to group_path(group), notice: "グループに参加しました"
  end
end
