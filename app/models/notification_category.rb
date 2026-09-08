class NotificationCategory
  ALL = [
    {
      key: "work_item_status_changed",
      label: "Work item status changes",
      description: "When a work item you're assigned to changes status.",
      permission_key: "workspace.work_items.index"
    }
  ].freeze

  def self.all = ALL
  def self.keys = ALL.map { |c| c[:key] }
  def self.visible_to(user) = ALL.select { |c| user.can?(c[:permission_key]) }
  def self.find(key) = ALL.find { |c| c[:key] == key.to_s }
end
