class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [ :read, :destroy ]

  rescue_from ActiveRecord::RecordNotFound do
    render turbo_stream: notification_panel_streams
  end

  def read
    @notification.update(read_at: Time.current) if @notification.unread?

    if @notification.url.present?
      redirect_to @notification.url
    else
      render turbo_stream: notification_panel_streams
    end
  end

  def read_all
    current_user.notifications.unread.update_all(read_at: Time.current)
    render turbo_stream: notification_panel_streams
  end

  def destroy
    @notification.destroy
    render turbo_stream: notification_panel_streams
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end

  def notification_panel_streams
    [
      turbo_stream.replace("notification_list", partial: "notifications/items",
        locals: { notifications: current_user.notifications.recent.limit(10) }),
      turbo_stream.replace("notification_badge", partial: "notifications/badge", locals: { user: current_user }),
      turbo_stream.replace("notification_mark_all_read", partial: "notifications/mark_all_read", locals: { user: current_user })
    ]
  end
end
