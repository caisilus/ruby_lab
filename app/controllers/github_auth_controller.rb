require 'octokit'

class GithubAuthController < ApplicationController
  def callback
    github_client = get_github_client(params[:code])

    raise ActionController::InvalidAuthenticityToken if github_client.nil?

    user = User.find_by(github_login: github_client.login)

    return redirect_to users_new_url if user.nil?

    session[:current_user_id] = user.id
    redirect_to labs_url
  end

  def destroy
    session.delete(:github_access_token)
    session.delete(:current_user_id)
    redirect_to labs_url
  end

  private

  def get_github_client(temp_code)
    result = Octokit::Client.new.exchange_code_for_token(temp_code.to_s, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'],
                                                         {accept: 'application/json'})

    return nil unless result.key?(:access_token)

    session[:github_access_token] = result[:access_token]
    Octokit::Client.new(access_token: result[:access_token])
  end
end
