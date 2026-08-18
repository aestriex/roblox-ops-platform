module IconHelper
  ICONS = {
    dashboard: '<path d="M3 3h7v9H3zM14 3h7v5h-7zM14 12h7v9h-7zM3 16h7v5H3z"/>',
    postings: '<path d="M3 7h18M3 12h18M3 17h18"/>'
  }.freeze

  def icon(name, css_class: "w-4 h-4")
    raw_path = ICONS[name.to_sym]
    return "" unless raw_path

    content_tag(:svg, raw_path.html_safe,
      xmlns: "http://www.w3.org/2000/svg",
      viewBox: "0 0 24 24",
      fill: "none",
      stroke: "currentColor",
      "stroke-width": "2",
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      class: css_class)
  end
end
