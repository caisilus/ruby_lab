class RepositoryController < ApplicationController
  def new
  end

  def create
    link = params[:link]

    subscribe_to_repo link

    redirect_to labs_url
  end

  private

  def subscribe_to_repo(link)
    client = Octokit::Client.new access_token: session[:github_access_token]
    client.subscribe("#{link}/events/push", @host_url + payload_path)
  end
end
