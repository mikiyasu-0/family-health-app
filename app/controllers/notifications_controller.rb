class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
                                 .preload(notifiable: :user)
                                 .order(created_at: :desc)
  end
end
