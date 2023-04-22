require 'octokit'

class GithubAuthController < ApplicationController
  def new
    @authorize_url = Octokit::Client.new.authorize_url ENV["GITHUB_CLIENT_ID"], options = { scope: "repo" }
  end

  def callback
    code = params[:code]
    result = Octokit::Client.new.exchange_code_for_token(code.to_s, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'],
                                                         {accept: 'application/json'})

    raise ActionController::InvalidAuthenticityToken unless result.key?(:access_token)

    client = Octokit::Client.new(access_token: result[:access_token])
    user = User.find_by(github_login: client.login)

    session[:github_access_token] = result[:access_token]
    return redirect_to users_new_url if user.nil?

    session[:current_user] = user
    redirect_to labs_url
  end
end
