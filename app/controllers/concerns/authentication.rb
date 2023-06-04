module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  private

  def set_current_user
    current_user = User.find_by(id: session[:current_user_id])
    if current_user.nil?
      unable_to_auth
      return
    end

    Current.user = current_user
  end

  def unable_to_auth
    unless session[:current_user_id].nil?
      session.delete(:current_user_id)
      session.delete(:github_access_token)
    end

    Current.user = nil
    setup_github_auth_link
  end

  def setup_github_auth_link
    Current.authorize_url = Octokit::Client.new.authorize_url ENV["GITHUB_CLIENT_ID"], options = { scope: "repo" }
  end
end
