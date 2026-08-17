module NavigationHelper
  NAV_STRUCTURE = [
    { section: nil, items: [
      { label: "Dashboard", path: :root_path, icon: "layout-dashboard", permission: nil }
    ]},
    { section: "Hiring", items: [
      { label: "Job Postings", path: :hiring_job_postings_path, icon: "briefcase", permission: "hiring.job_postings.index" }
    ]},
    { section: "Development", items: [
      { label: "Projects", path: :workspace_projects_path, icon: "folder", permission: "workspace.projects.index" }
    ]},
    { section: "Personnel", items: [
      { label: "People", path: :personnel_people_path, icon: "users", permission: "personnel.people.index" }
    ]},
    { section: "Admin", items: [
      { label: "Role Management", path: :admin_roles_path, icon: "key", permission: "admin.roles.index" },
      { label: "User Management", path: :admin_users_path, icon: "user", permission: "admin.users.index" }
    ]}
  ].freeze

  def visible_nav_sections
    NAV_STRUCTURE.filter_map do |section|
      visible_items = section[:items].select { |item| item[:permission].nil? || current_user.can?(item[:permission]) }
      { section: section[:section], items: visible_items } if visible_items.any?
    end
  end
end
