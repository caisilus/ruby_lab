module ApplicationHelper
  def nav_link(name, url)
    link_to name, url, data: { action: "navbar#enable_section",
                               "navbar-target": "section" }
  end
end
