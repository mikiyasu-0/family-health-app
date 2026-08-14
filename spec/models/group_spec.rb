require "rails_helper"

RSpec.describe Group, type: :model do
  describe "バリデーション" do
    it "有効なグループを作成できる" do
      group = build(:group)

      expect(group).to be_valid
    end

    it "グループ名が未入力の場合は無効である" do
      group = build(:group, name: nil)

      expect(group).not_to be_valid
    end
  end
end
