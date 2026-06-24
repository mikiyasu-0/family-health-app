require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "ログイン中のユーザーは自分の運動記録にコメントできる" do
    exercise_record = exercise_records(:one)
    user = exercise_record.user

    sign_in user

    assert_difference("Comment.count", 1) do
      post exercise_record_comments_url(exercise_record), params: {
        comment: {
          body: "いいですね！"
        }
      }
    end

    assert_redirected_to dashboard_path
  end
end
