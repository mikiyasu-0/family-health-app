class Users::RegistrationsController < Devise::RegistrationsController
before_action :ensure_not_guest_user, only: %i[edit update destroy]

  protected

  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      resource.update_with_password(params)
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(_resource)
    mypage_path
  end

  private

  def ensure_not_guest_user
    return unless current_user&.guest?

    redirect_to mypage_path, alert: "ゲストユーザーはアカウントの編集・削除できません。"
  end
end
