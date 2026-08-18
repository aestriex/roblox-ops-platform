module ModuleGated
  extend ActiveSupport::Concern

  NAMESPACE_MODULES = {
    "hiring" => "hiring",
    "workspace" => "workspace",
    "personnel" => "personnel"
  }.freeze

  included do
    class_attribute :gated_module, default: nil
    before_action :enforce_module_enabled!
  end

  class_methods do
    def restrict_to_module(key)
      self.gated_module = key.to_s
    end
  end

  private

  def enforce_module_enabled!
    key = gated_module || NAMESPACE_MODULES[controller_path.split("/").first]
    return unless key
    raise ActionController::RoutingError, "Not Found" unless Configuration.instance.module_enabled?(key)
  end
end
