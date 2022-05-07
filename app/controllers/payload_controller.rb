class PayloadController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    parsed_params = parse_params
    base_folder = File.join(Dir.home, ENV['SANDBOX_FOLDER'])
    folder_path = File.join(base_folder, parsed_params["owner"]["name"].to_s)
    tests_folder = File.join(base_folder, "tests")
    repo = parsed_params["full_name"].to_s
    RunTestsJob.perform_later(repo, folder_path, tests_folder)
  end

  private

  def parse_params
    json = JSON.parse params.require(:payload)
    json["repository"]
  end
end
