require "rails_helper"

RSpec.describe ExerciseRecord, type: :model do
  describe "バリデーション" do
    it "有効な運動記録を作成できる" do
      exercise_record = build(:exercise_record)

      expect(exercise_record).to be_valid
    end

    it "exercise_typeが未入力の場合は無効である" do
      exercise_record = build(:exercise_record, exercise_type: nil)

      expect(exercise_record).not_to be_valid
    end

    it "同じ日に同じ運動を重複して記録できない" do
      user = create(:user)

      create(
        :exercise_record,
        user: user,
        exercise_type: "walk"
      )

      duplicate_record = build(
        :exercise_record,
        user: user,
        exercise_type: "walk"
      )

      expect(duplicate_record).not_to be_valid
    end

    it "翌日なら同じ運動を記録できる" do
      user = create(:user)

      create(
        :exercise_record,
        user: user,
        exercise_type: "walk"
      )

      travel_to 1.day.from_now do
        next_day_record = build(
          :exercise_record,
          user: user,
          exercise_type: "walk"
        )

        expect(next_day_record).to be_valid
      end
    end
  end
end
