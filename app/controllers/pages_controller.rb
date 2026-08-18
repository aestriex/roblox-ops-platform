class PagesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def dashboard
    @modules = []

    if Configuration.instance.module_enabled?("hiring")
      @modules << {
        title: "Hiring",
        icon: "briefcase",
        path: hiring_job_postings_path,
        stats: [
          { label: "Open Postings", value: Hiring::JobPosting.where(status: "open").count },
          { label: "Pending Submissions", value: Hiring::PostingApplication.where(status: "in_progress").count }
        ]
      }
    end

    if Configuration.instance.module_enabled?("personnel")
      @modules << {
        title: "Personnel",
        icon: "users",
        path: personnel_people_path,
        stats: [
          { label: "Active", value: Personnel::Person.where(status: "active").count },
          { label: "On Leave", value: Personnel::Person.where(status: "on_leave").count }
        ]
      }
    end

    if Configuration.instance.module_enabled?("workspace")
      @modules << {
        title: "Workspace",
        icon: "layout-grid",
        path: workspace_projects_path,
        stats: [
          { label: "Active Projects", value: Workspace::Project.count },
          { label: "Blocked Items", value: Workspace::WorkItem.where(blocked: true).count }
        ]
      }
    end
  end
end
