require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /users" do
    context "有効なユーザー情報の場合" do
      it "ユーザーを新規登録できる" do
        expect {
          post user_registration_path, params: {
            user: {
              name: "テストユーザー",
              email: "test@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)
      end
    end

    context "名前が未入力の場合" do
      it "ユーザーを新規登録できない" do
        expect {
          post user_registration_path, params: {
            user: {
              name: "",
              email: "test@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.not_to change(User, :count)
      end
    end

    context "メールアドレスが未入力の場合" do
      it "ユーザーを新規登録できない" do
        expect {
          post user_registration_path, params: {
            user: {
              name: "テストユーザー",
              email: "",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.not_to change(User, :count)
      end
    end

    context "パスワードが未入力の場合" do
      it "ユーザーを新規登録できない" do
        expect {
          post user_registration_path, params: {
            user: {
              name: "テストユーザー",
              email: "test@example.com",
              password: "",
              password_confirmation: ""
            }
          }
        }.not_to change(User, :count)
      end
    end
  end

  describe "POST /users/sign_in" do
    context "正しいメールアドレスとパスワードの場合" do
      it "ログインしてdashboardへ遷移する" do
        user = create(:user)
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET /dashboard" do
    context "未ログインの場合" do
      it "dashboardへアクセスできない" do
        get dashboard_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    context "ログインしている場合" do
      it "ログアウトしてトップページへ遷移する" do
        user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        delete destroy_user_session_path

        expect(response).to redirect_to(root_path)
      end

      it "ログアウト後はdashboardへアクセスできない" do
        user = create(:user)

        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        delete destroy_user_session_path

        get dashboard_path
        
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
