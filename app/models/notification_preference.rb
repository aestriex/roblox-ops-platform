class NotificationPreference < ApplicationRecord
  belongs_to :user

  validates :category, presence: true, uniqueness: { scope: :user_id }
end
