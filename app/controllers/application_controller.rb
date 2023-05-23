class ApplicationController < ActionController::Base
  include Authentication
  include SetHostUrl

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false
  end
end
