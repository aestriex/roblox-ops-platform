class Configuration < ApplicationRecord
  MODULES = {
    "hiring" => "Hiring",
    "workspace" => "Workspace",
    "personnel" => "Personnel"
  }.freeze

  # Lucide icon name shown next to each module's name, e.g. in breadcrumbs.
  # Includes "admin", which isn't in MODULES since it can't be disabled.
  MODULE_ICONS = {
    "hiring" => "briefcase",
    "workspace" => "wrench",
    "personnel" => "users",
    "admin" => "shield"
  }.freeze

  def self.instance
    first_or_create!(org_name: "Studio Proviso")
  end

  def external_links
    (super || []).map(&:with_indifferent_access)
  end

  def disabled_modules
    super || []
  end

  def module_enabled?(key)
    !disabled_modules.include?(key.to_s)
  end
end
