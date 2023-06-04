class CourseController < ApplicationController
  def index
    @units = Unit.all
  end
end
