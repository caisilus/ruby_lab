class UsersController < ApplicationController
  def new
    registration_form
  end

  def create
    parsed_params = parse_params.merge(github_user)
    user = User.new parsed_params

    link = parsed_params[:repo_link]

    success = subscribe_to_repo(link)

    return form_with_errors(["Некорректная ссылка на репозиторий."]) unless success

    user.repo_link = link.gsub("https://github.com/", "")

    return form_with_errors(user.errors.full_messages) unless user.save

    session[:current_user_id] = user.id

    redirect_to labs_url
  end

  private

  def registration_form
    form_with_errors([])
  end

  def form_with_errors(error_messages)
    render :new, status: :unprocessable_entity, locals: { error_messages: error_messages }
  end

  def parse_params
    params.permit(:surname, :name, :middle_name, :repo_link)
  end

  def github_user
    github_user = Octokit::Client.new(access_token: session[:github_access_token]).user

    { github_login: github_user[:login], avatar_url: github_user[:avatar_url] }
  end

  def subscribe_to_repo(link)
    client = Octokit::Client.new(access_token: session[:github_access_token])
    begin
      client.subscribe("#{link}/events/push", Current.host_url + payload_path)
    rescue Octokit::UnprocessableEntity => e
      false
    end
  end
end
