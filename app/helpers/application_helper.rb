module ApplicationHelper
  # Like lucide_icon, but for user-supplied icon names (e.g. Configuration's
  # external links) that may not correspond to a real Lucide icon. Renders
  # nothing instead of raising and breaking the whole page.
  def safe_lucide_icon(name, **options)
    lucide_icon(name, **options) if name.present?
  rescue ArgumentError
    nil
  end
end
