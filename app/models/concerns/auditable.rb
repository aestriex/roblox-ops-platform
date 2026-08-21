module Auditable
  extend ActiveSupport::Concern

  included do
    after_create { AuditLog.record!(action: "create", auditable: self, changes: saved_changes) }
    after_update { AuditLog.record!(action: "update", auditable: self, changes: saved_changes) }
    after_destroy { AuditLog.record!(action: "destroy", auditable: self, changes: attributes) }
  end
end
