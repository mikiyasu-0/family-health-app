class Admin::GuestUserCleanupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin_user

  def create
    result = GuestUserCleanupService.new.call

    redirect_to mypage_path,
                notice: "ゲストデータ削除が完了しました。削除ユーザー: #{result[:deleted_users]}件、削除グループ: #{result[:deleted_groups]}件"
  end

  private

  def ensure_admin_user
    return if admin_user?

    redirect_to root_path, alert: "権限がありません。"
  end
end
