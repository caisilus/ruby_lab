class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    if session[:current_user_id].nil?
      @current_user = nil
      return
    end

    @current_user = User.find(session[:current_user_id])
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false
  end
end
