class UsersController < ApplicationController
  def new
  end

  def create
    github_user = Octokit::Client.new(access_token: session[:github_access_token]).user

    parsed_params = parse_params

    user = User.new parsed_params
    user.github_login = github_user[:login]
    user.avatar_url = github_user[:avatar_url]

    link = parsed_params[:repo_link]

    subscribe_to_repo link

    user.repo_link = link.gsub("https://github.com/", "")
    user.save

    session[:current_user_id] = user.id

    redirect_to labs_url
  end

  private

  def parse_params
    params.permit(:surname, :name, :middle_name, :repo_link)
  end

  def subscribe_to_repo(link)
    client = Octokit::Client.new access_token: session[:github_access_token]
    client.subscribe("#{link}/events/push", Current.host_url + payload_path)
  end
end
