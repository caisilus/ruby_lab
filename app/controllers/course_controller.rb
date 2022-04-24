class CourseController < ApplicationController
  def index
    @groups = Group.all
  end
end
