class PayloadController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    parsed_params = parse_params

    return if parsed_params.nil?

    base_dir = ENV['SANDBOX_DIRECTORY']

    username = parsed_params["owner"]["login"].to_s
    user_dir = File.join(base_dir, username)

    Dir.mkdir user_dir unless Dir.exist? user_dir

    tests_dir = File.join(base_dir, "tests")
    repo = parsed_params["full_name"].to_s

    labs_h = parsed_params["labs"]

    labs_h.each do |lab_id, task_indices|
      lab = Lab.find(lab_id)
      task_indices.each do |index|
        task_dir = File.join(user_dir, "lab#{lab_id}_task#{index}")
        files_dir_path = File.join("lab#{lab_id}", "task#{index}")
        task = lab.tasks.find_by(index_number: index)
        test_file = task.test_filename
        result = task.last_result
        RunTestsJob.perform_later(repo, task_dir, tests_dir, test_file, files_dir_path, result)
      end
    end
  end

  private

  def parse_params
    return nil unless params.has_key?(:payload)

    json = JSON.parse params.require(:payload)

    puts json[:ref]

    return nil unless json.has_key?("commits")

    files_set = committed_files_set json["commits"]

    labs = labs_hash(files_set)
    json["repository"].merge({ "labs" => labs })
  end

  def committed_files_set(commits)
    files_set = Set.new
    commits.each do |commit|
      files_set.merge(commit["added"])
      files_set.merge(commit["modified"])
    end
    files_set
  end

  # TODO: bad name
  def labs_hash(files_set)
    labs_hash = Hash.new { |hash, key| hash[key] = Array.new }

    files_set.each do |full_path|
      update_labs_hash(full_path, labs_hash)
    end

    labs_hash
  end

  def update_labs_hash(file_path, labs_hash)
    tokens = file_path.split("/")

    raise "must be at least 3 tokens in path" if tokens.length != 3

    lab_id = tokens.first.gsub("lab", "").to_i
    task_id = tokens[1].gsub("task", "").to_i

    labs_hash[lab_id] << task_id
  end
end
