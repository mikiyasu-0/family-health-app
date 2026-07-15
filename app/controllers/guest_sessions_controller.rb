class GuestSessionsController < ApplicationController
  def create
    if user_signed_in?
      redirect_to dashboard_path
      return
    end

    guest_user = ActiveRecord::Base.transaction do
      user = User.create_guest!
      GuestSampleDataCreator.new(user).call
      user
    end

    sign_in guest_user

    redirect_to dashboard_path, notice: "ゲストユーザーとしてログインしました。"
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: "ゲストログインに失敗しました。時間をおいて再度お試しください。"
  end
end
