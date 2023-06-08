class SidebarPagesController < ApplicationController
  layout 'sidebar'

  before_action :set_sidebar_content

  def set_sidebar_content
    @sidebar_groups = Unit.all.order(:created_at)
  end
end
