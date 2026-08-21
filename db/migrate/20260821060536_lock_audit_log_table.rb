class LockAuditLogTable < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      REVOKE UPDATE, DELETE ON audit_logs FROM CURRENT_USER;
    SQL
  end

  def down
    execute <<~SQL
      GRANT UPDATE, DELETE ON audit_logs TO CURRENT_USER;
    SQL
  end
end
