class Configuration < ApplicationRecord
  MODULES = {
    "hiring" => "Hiring",
    "workspace" => "Workspace",
    "personnel" => "Personnel"
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
