module BreadcrumbsHelper
  def auto_breadcrumbs
    segments = request.path.split("/").reject(&:blank?)
    crumbs = []

    if segments.empty?
      crumbs << { label: "Dashboard", path: nil, icon: "sparkles" }
      return crumbs
    end

    path_so_far = ""
    segments.each_with_index do |segment, index|
      path_so_far += "/#{segment}"

      if index.zero?
        # The module root (e.g. "workspace", "hiring") has no overview route
        # of its own, so it isn't a link -- just a labeled icon.
        crumbs << { label: humanize_segment(segment), path: nil, icon: Configuration::MODULE_ICONS[segment] }
      elsif segment.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-/)
        crumbs << { label: resolve_record_label(segments, segment), path: path_so_far }
      else
        crumbs << { label: humanize_segment(segment), path: path_so_far }
      end
    end

    crumbs.last[:path] = nil if crumbs.any?
    crumbs
  end

  private

  def resolve_record_label(segments, uuid)
    resource_name = segments[segments.index(uuid) - 1]

    case resource_name
    when "job_postings"
        Hiring::JobPosting.find_by(id: uuid)&.title
    when "sections"
        Hiring::Section.find_by(id: uuid)&.title
    when "roles"
        Role.find_by(id: uuid)&.name
    when "users"
        User.find_by(id: uuid)&.display_name
    when "posting_applications"
        Hiring::PostingApplication.find_by(id: uuid)&.user&.display_name
    when "projects"
        Workspace::Project.find_by(id: uuid)&.name
    when "features"
        Workspace::Feature.find_by(id: uuid)&.name
    when "deliverables"
        Workspace::Deliverable.find_by(id: uuid)&.name
    when "work_items"
        Workspace::WorkItem.find_by(id: uuid)&.title
    else
        uuid
    end
    end

  def humanize_segment(segment)
    case segment
    when "posting_applications"
      "Submissions"
    else
      segment.titleize
    end
  end
end
