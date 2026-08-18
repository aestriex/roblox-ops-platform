module PermissionRegistry
  def self.entries
    @entries ||= []
  end

  def self.register(key:, description:, auto_assign:)
    entries << { key: key, description: description, auto_assign: auto_assign }
  end
end
