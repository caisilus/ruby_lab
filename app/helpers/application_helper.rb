module ApplicationHelper
  def nav_link(name, url, selected)
    link_to name, url,
            class: "#{name == selected ? current_nav_class : default_nav_class} inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
  end

  def mobile_nav_link(name, url, selected)
    link_to name, url,
            class: "#{name == selected ? current_nav_mobile_class : default_nav_mobile_class} block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
  end

  private

  def current_nav_class
    "border-indigo-500 text-gray-900"
  end

  def default_nav_class
    "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
  end

  def current_nav_mobile_class
    "bg-indigo-50 border-indigo-500 text-indigo-700"
  end

  def default_nav_mobile_class
    "border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700"
  end
end
