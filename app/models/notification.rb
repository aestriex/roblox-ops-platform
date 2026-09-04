class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :title, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def self.notify!(recipient:, title:, body: nil, url: nil, notifiable: nil)
    create!(recipient: recipient, title: title, body: body, url: url, notifiable: notifiable)
  end

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end
end
