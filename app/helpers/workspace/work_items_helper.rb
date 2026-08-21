module Workspace
  module WorkItemsHelper
    ACTIVITY_IGNORED_FIELDS = %w[id created_at updated_at deliverable_id].freeze

    ACTIVITY_FIELD_LABELS = {
      "description" => "description",
      "blocked_reason" => "blocked reason"
    }.freeze

    def activity_log_summary(log)
      case log.action
      when "create"
        "created this work item"
      when "destroy"
        "deleted this work item"
      else
        changes = (log.changes_data || {}).except(*ACTIVITY_IGNORED_FIELDS)
        return "updated this work item" if changes.empty?

        changes.map { |field, (from, to)| activity_field_change(field, from, to) }.to_sentence
      end
    end

    private

    def activity_field_change(field, from, to)
      case field
      when "title"
        "renamed this to \"#{to}\""
      when "status"
        "changed status from #{from&.titleize || "—"} to #{to&.titleize || "—"}"
      when "assignee_id"
        "changed assignee to #{Personnel::Person.find_by(id: to)&.full_name || "Unassigned"}"
      when "due_date"
        to.present? ? "set the due date to #{Date.parse(to).strftime('%b %-d, %Y')}" : "cleared the due date"
      when "blocked"
        to ? "marked this blocked" : "cleared the blocked flag"
      else
        "updated #{ACTIVITY_FIELD_LABELS.fetch(field, field.humanize.downcase)}"
      end
    end
  end
end
