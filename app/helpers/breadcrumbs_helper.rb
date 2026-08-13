module BreadcrumbsHelper
  def auto_breadcrumbs
    segments = request.path.split("/").reject(&:blank?)
    crumbs = []

    if segments.empty?
      crumbs << { label: "Dashboard", path: nil }
      return crumbs
    end

    path_so_far = ""
    segments.each do |segment|
      path_so_far += "/#{segment}"

      if segment.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-/)
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
      JobPosting.find_by(id: uuid)&.title
    when "sections"
      Section.find_by(id: uuid)&.title
    when "roles"
      Role.find_by(id: uuid)&.name
    when "users"
      User.find_by(id: uuid)&.display_name
    when "posting_applications"
      PostingApplication.find_by(id: uuid)&.user&.display_name
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
