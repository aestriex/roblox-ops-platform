class NotificationPreferencesController < ApplicationController
  before_action :authenticate_user!

  def update
    NotificationCategory.visible_to(current_user).each do |category|
      enabled = ActiveModel::Type::Boolean.new.cast(params.dig(:notification_preferences, category[:key]))
      pref = current_user.notification_preferences.find_or_initialize_by(category: category[:key])
      pref.update!(enabled: enabled)
    end

    redirect_back fallback_location: root_path, notice: "Notification preferences updated."
  end
end
