require "rails_helper"

RSpec.describe "Groups", type: :request do
  describe "POST /groups" do
    context "ログインしている場合" do
      it "グループを作成できる" do
        user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        expect {
          post groups_path, params: {
            group: {
              name: "テストグループ"
            }
          }
        }.to change(Group, :count).by(1)

        group = Group.last

        membership = GroupMembership.find_by(
          group: group,
          user: user
        )

        expect(membership).to be_present
        expect(membership).to be_admin
      end

      it "作成したグループが一覧に表示される" do
        user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        post groups_path, params: {
          group: {
            name: "テストグループ"
          }
        }

        get groups_path

        expect(response.body).to include("テストグループ")
      end
    end

    context "未ログインの場合" do
      it "グループを作成できない" do
        expect {
          post groups_path, params: {
            group: {
              name: "テストグループ"
            }
          }
        }.not_to change(Group, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
