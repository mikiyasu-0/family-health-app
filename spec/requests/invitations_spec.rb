require "rails_helper"

RSpec.describe "Invitations", type: :request do
  describe "POST /groups/:group_id/invitations" do
    context "ログインしている場合" do
      it "招待を作成できる" do
        user = create(:user)
        group = create(:group)

        create(
          :group_membership,
          user: user,
          group: group,
          role: :admin
        )

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        expect {
          post group_invitations_path(group)
        }.to change(Invitation, :count).by(1)

        invitation = Invitation.last

        expect(invitation.group).to eq(group)
        expect(invitation.invited_by).to eq(user)
        expect(response).to redirect_to(
          share_invitation_path(invitation.token)
        )
      end
    end
  end

  describe "POST /group_memberships/accept" do
    context "有効な招待の場合" do
      it "グループに参加できる" do
        inviter = create(:user)
        invitee = create(:user)
        group = create(:group)

        create(
          :group_membership,
          user: inviter,
          group: group,
          role: :admin
        )

        invitation = create(
          :invitation,
          group: group,
          invited_by: inviter,
          expires_at: 1.day.from_now,
          status: :pending
        )

        get invitation_path(invitation.token)

        post user_session_path, params: {
          user: {
            email: invitee.email,
            password: "password123"
          }
        }

        expect {
          post accept_group_memberships_path
        }.to change(GroupMembership, :count).by(1)

        membership = GroupMembership.find_by(
          user: invitee,
          group: group
        )

        expect(membership).to be_present

        invitation.reload

        expect(invitation).to be_accepted
        expect(invitation.used_by).to eq(invitee)
        expect(invitation.accepted_at).to be_present
      end
    end

    context "期限切れの招待の場合" do
      it "招待URLを利用できない" do
        inviter = create(:user)
        group = create(:group)

        invitation = create(
          :invitation,
          group: group,
          invited_by: inviter,
          expires_at: 1.day.ago,
          status: :pending
        )

        get invitation_path(invitation.token)

        expect(response).to redirect_to(root_path)
      end
    end

    context "使用済みの招待の場合" do
      it "招待URLを再利用できない" do
        inviter = create(:user)
        used_user = create(:user)
        group = create(:group)

        invitation = create(
          :invitation,
          group: group,
          invited_by: inviter,
          used_by: used_user,
          status: :accepted,
          expires_at: 1.day.from_now
        )

        get invitation_path(invitation.token)

        expect(response).to redirect_to(root_path)
      end
    end

    context "すでにグループに参加している場合" do
      it "重複して参加しない" do
        inviter = create(:user)
        invitee = create(:user)
        group = create(:group)

        create(
          :group_membership,
          user: inviter,
          group: group,
          role: :admin
        )

        create(
          :group_membership,
          user: invitee,
          group: group,
          role: :member
        )

        invitation = create(
          :invitation,
          group: group,
          invited_by: inviter,
          expires_at: 1.day.from_now,
          status: :pending
        )

        get invitation_path(invitation.token)

        post user_session_path, params: {
          user: {
            email: invitee.email,
            password: "password123"
          }
        }

        expect {
          post accept_group_memberships_path
        }.not_to change(GroupMembership, :count)

        expect(response).to redirect_to(group_path(group))
      end
    end

    context "未ログインの場合" do
      it "新規登録へ誘導される" do
        inviter = create(:user)
        group = create(:group)

        invitation = create(
          :invitation,
          group: group,
          invited_by: inviter,
          expires_at: 1.day.from_now,
          status: :pending
        )

        get invitation_path(invitation.token)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("参加する")
        expect(response.body).to include(new_user_session_path)
      end
    end
  end
end
