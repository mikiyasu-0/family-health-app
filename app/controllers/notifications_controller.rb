class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
                                 .preload(notifiable: :user)
                                 .order(created_at: :desc)
                                 .to_a

    @unread_notification_ids = @notifications.select(&:unread?).map(&:id)

    current_user.notifications.unread.update_all(
      read_at: Time.current,
      updated_at: Time.current
    )
  end
end
