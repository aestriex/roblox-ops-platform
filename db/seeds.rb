Role.find_or_create_by!(name: "Applicant") do |role|
  role.description = "External candidate applying for a position"
end

Role.find_or_create_by!(name: "Staff") do |role|
  role.description = "Can view and manage job postings"
end

Role.find_or_create_by!(name: "Manager") do |role|
  role.description = "Full access to forms and exports"
end

Role.find_or_create_by!(name: "Super Admin") do |role|
  role.description = "Full system access, including role management"
end
