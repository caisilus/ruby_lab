class UsersController < ApplicationController
  def new
  end

  def create
    github_user = Octokit::Client.new(access_token: session[:github_access_token]).user

    parsed_params = parse_params

    user = User.new
    user.name = parsed_params[:name]
    user.middle_name = parsed_params[:middle_name] if parsed_params.has_key? :middle_name
    user.surname = parsed_params[:surname]
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
    params.permit(:surname, :name, :middle_name, :avatar_url, :repo_link)
  end

  def subscribe_to_repo(link)
    client = Octokit::Client.new access_token: session[:github_access_token]
    client.subscribe("#{link}/events/push", Current.host_url + payload_path)
  end
end
