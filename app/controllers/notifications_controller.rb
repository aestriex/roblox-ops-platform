class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: :read

  def read
    @notification.update(read_at: Time.current) if @notification.unread?
    redirect_to @notification.url.presence || request.referer || root_path
  end

  def read_all
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_back fallback_location: root_path
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
