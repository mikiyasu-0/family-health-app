require "rails_helper"

RSpec.describe "ExerciseRecords", type: :request do
  describe "POST /exercise_records" do
    context "ログインしている場合" do
      it "運動記録を作成できる" do
        user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        expect {
          post exercise_records_path, params: {
            exercise_record: {
              exercise_type: "walk"
            }
          }
        }.to change(ExerciseRecord, :count).by(1)

        record = ExerciseRecord.last

        expect(record.user).to eq(user)
      end
    end

    context "未ログインの場合" do
      it "運動記録を作成できない" do
        expect {
          post exercise_records_path, params: {
            exercise_record: {
              exercise_type: "walk"
            }
          }
        }.not_to change(ExerciseRecord, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /exercise_records/:id" do
    context "自分の運動記録の場合" do
      it "メモを更新できる" do
        user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        record = create(
          :exercise_record,
          user: user,
          memo: "更新前のメモ"
        )

        patch exercise_record_path(record), params: {
          exercise_record: {
            memo: "更新後のメモ"
          }
        }

        expect(record.reload.memo).to eq("更新後のメモ")
      end
    end

    context "他人の運動記録の場合" do
      it "メモを更新できない" do
        user = create(:user)
        other_user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        record = create(
          :exercise_record,
          user: other_user,
          memo: "更新前のメモ"
        )

        patch exercise_record_path(record), params: {
          exercise_record: {
            memo: "更新後のメモ"
          }
        }

        expect(response).to have_http_status(:not_found)
        expect(record.reload.memo).to eq("更新前のメモ")
      end
    end
  end
end
