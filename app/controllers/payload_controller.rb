class PayloadController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    parsed_params = parse_params

    return if parsed_params.nil?

    user = get_user_from_push_params(parsed_params)

    tasks = committed_tasks(parsed_params["commits"])
    tasks.each do |task|
      RunTestsJob.perform_later(user, task)
    end
  end

  private

  def parse_params
    return nil unless params.has_key?(:payload)

    json = JSON.parse params.require(:payload)

    return nil unless json.has_key?("commits")

    json
  end

  def get_user_from_push_params(parsed_params)
    username = parsed_params["repository"]["owner"]["login"].to_s
    user = User.find_by(github_login: username)

    repo = parsed_params["repository"]["full_name"].to_s

    if repo != user.repo_link
      puts "#{repo} != #{user.repo_link}"
      return nil
    end

    user
  end

  def committed_tasks(commits)
    files_set = committed_files_set(commits)

    files_set.map { |filename| get_task_by_filename(filename) }
  end

  def committed_files_set(commits)
    files_set = Set.new
    commits.each do |commit|
      files_set.merge(commit["added"])
      files_set.merge(commit["modified"])
    end
    files_set
  end

  # lab{n}/task{m}/filename => Task number m in Lab number n should be tested
  def get_task_by_filename(file_path)
    tokens = file_path.split("/")

    raise "must be at least 3 tokens in path" if tokens.length != 3

    lab_id = tokens.first.gsub("lab", "").to_i
    task_index = tokens.second.gsub("task", "").to_i

    Lab.find(lab_id).tasks.find_by(index_number: task_index)
  end
end
