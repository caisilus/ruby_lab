class ApplicationController < ActionController::Base
  before_action :set_host_url, :set_current_user

  private

  def set_host_url
    @host_url = request.protocol + request.host
  end

  def set_current_user
    if session[:current_user_id].nil?
      @current_user = nil
      setup_github_auth_link
      return
    end

    @current_user = User.find(session[:current_user_id])
  end

  def setup_github_auth_link
    @authorize_url = Octokit::Client.new.authorize_url ENV["GITHUB_CLIENT_ID"], options = { scope: "repo" }
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false
  end
end
