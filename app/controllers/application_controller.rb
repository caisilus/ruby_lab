class ApplicationController < ActionController::Base
  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false
  end
end
