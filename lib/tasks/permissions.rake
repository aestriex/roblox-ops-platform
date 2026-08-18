namespace :permissions do
  task sync: :environment do
    Rails.application.eager_load!

    PermissionRegistry.entries.each do |entry|
      permission = Permission.find_or_create_by!(key: entry[:key]) do |p|
        p.description = entry[:description]
      end

      entry[:auto_assign].each do |role_name|
        role = Role.find_or_create_by!(name: role_name)
        role.permissions << permission unless role.permissions.include?(permission)
      end
    end

    puts "Synced #{PermissionRegistry.entries.size} permissions."
  end

  task check: :environment do
    Rails.application.eager_load!
    declared_keys = PermissionRegistry.entries.map { |e| e[:key] }
    orphaned = Permission.where.not(key: declared_keys)

    if orphaned.any?
        puts "⚠️  These permissions exist in the DB but aren't declared in any controller:"
        orphaned.each { |p| puts "  - #{p.key}" }
    else
        puts "✅ All permissions match current code."
    end
  end
end
