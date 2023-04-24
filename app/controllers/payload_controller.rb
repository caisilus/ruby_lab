class PayloadController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    parsed_params = parse_params

    return if parsed_params.nil?

    username = parsed_params["repository"]["owner"]["login"].to_s
    user = User.find_by(github_login: username)
    repo = parsed_params["repository"]["full_name"].to_s

    if repo != user.repo_link
      puts "#{repo} != #{user.repo_link}"
      return
    end

    files_set = committed_files_set parsed_params["commits"]
    tasks = tasks_list(files_set)
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

  def committed_files_set(commits)
    files_set = Set.new
    commits.each do |commit|
      files_set.merge(commit["added"])
      files_set.merge(commit["modified"])
    end
    files_set
  end

  def tasks_list(files_set)
    tasks_list = []

    files_set.each do |full_path|
      task = get_task_by_filename(full_path)
      tasks_list << task
    end

    tasks_list
  end

  def get_task_by_filename(file_path)
    tokens = file_path.split("/")

    raise "must be at least 3 tokens in path" if tokens.length != 3

    lab_id = tokens.first.gsub("lab", "").to_i
    task_index = tokens[1].gsub("task", "").to_i

    Lab.find(lab_id).tasks.find_by(index_number: task_index)
  end
end
