require "rails_helper"

RSpec.describe User, type: :model do
  describe "FactoryBot" do
    it "有効なユーザーを作成できる" do
      user = build(:user)

      expect(user).to be_valid
    end
  end
end
