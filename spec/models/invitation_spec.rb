require "rails_helper"

RSpec.describe Invitation, type: :model do
  describe "バリデーション" do
    it "有効な招待を作成できる" do
      invitation = build(:invitation)

      expect(invitation).to be_valid
    end

    it "招待ごとに異なるトークンが生成される" do
      invitation1 = create(:invitation)
      invitation2 = create(:invitation)

      expect(invitation1.token).not_to eq(invitation2.token)
    end
  end

  describe "#expired?" do
    it "有効期限内の場合はfalseを返す" do
      invitation = build(
        :invitation,
        expires_at: 1.day.from_now
      )

      expect(invitation.expired?).to eq(false)
    end

    it "有効期限切れの場合はtrueを返す" do
      invitation = build(
        :invitation,
        expires_at: 1.day.ago
      )

      expect(invitation.expired?).to eq(true)
    end
  end

  describe "#usable?" do
    it "未使用かつ有効期限内の場合はtrueを返す" do
      invitation = build(
        :invitation,
        status: :pending,
        expires_at: 1.day.from_now,
        used_by: nil
      )

      expect(invitation.usable?).to eq(true)
    end

    it "有効期限切れの場合はfalseを返す" do
      invitation = build(
        :invitation,
        status: :pending,
        expires_at: 1.day.ago,
        used_by: nil
      )

      expect(invitation.usable?).to eq(false)
    end

    it "acceptedの場合はfalseを返す" do
      invitation = build(
        :invitation,
        status: :accepted,
        expires_at: 1.day.from_now,
        used_by: nil
      )

      expect(invitation.usable?).to eq(false)
    end

    it "used_byが設定されている場合はfalseを返す" do
      used_user = create(:user)
      invitation = build(
        :invitation,
        status: :pending,
        expires_at: 1.day.from_now,
        used_by: used_user
      )

      expect(invitation.usable?).to eq(false)
    end
  end
end
