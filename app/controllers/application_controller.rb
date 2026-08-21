class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_current_user

  stale_when_importmap_changes

  include Permissible
  include ModuleGated

  private

  def set_current_user
    Current.user = current_user
  end
end
