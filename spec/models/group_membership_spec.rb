require "rails_helper"

RSpec.describe GroupMembership, type: :model do
  describe "バリデーション" do
    it "有効なグループメンバーシップを作成できる" do
      user = create(:user)
      group = create(:group)
      membership = build(
        :group_membership,
        user: user,
        group: group
      )

      expect(membership).to be_valid
    end

    it "同じユーザーを同じグループに重複して登録できない" do
      user = create(:user)
      group = create(:group)

      create(
        :group_membership,
        user: user,
        group: group
      )

      duplicate_membership = build(
        :group_membership,
        user: user,
        group: group
      )

      expect(duplicate_membership).not_to be_valid
    end
  end
end
