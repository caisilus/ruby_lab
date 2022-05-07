require 'octokit'

class GithubAuthController < ApplicationController
  def new
    @authorize_url = Octokit::Client.new.authorize_url ENV["GITHUB_CLIENT_ID"], options = { scope: "repo" }
  end

  def callback
    code = params[:code]
    result = Octokit::Client.new.exchange_code_for_token(code.to_s, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'])
    session[:github_access_token] = result[:access_token]
    redirect_to repository_new_url
  end
end
