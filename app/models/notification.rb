class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :title, presence: true
  validates :category, presence: true, inclusion: { in: ->(*) { NotificationCategory.keys } }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def self.notify!(recipient:, category:, title:, body: nil, url: nil, notifiable: nil)
    return nil unless recipient.notifications_enabled_for?(category)

    notification = create!(recipient: recipient, category: category, title: title, body: body, url: url, notifiable: notifiable)
    notification.broadcast_to_recipient
    notification
  end

  def broadcast_to_recipient
    Turbo::StreamsChannel.broadcast_replace_to(recipient, :notifications,
      target: "notification_list", partial: "notifications/items",
      locals: { notifications: recipient.notifications.recent.limit(10) })

    Turbo::StreamsChannel.broadcast_replace_to(recipient, :notifications,
      target: "notification_badge", partial: "notifications/badge", locals: { user: recipient })

    Turbo::StreamsChannel.broadcast_replace_to(recipient, :notifications,
      target: "notification_mark_all_read", partial: "notifications/mark_all_read", locals: { user: recipient })
  end

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end
end
