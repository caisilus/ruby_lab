class PayloadController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    parsed_params = parse_params

    return if parsed_params.nil?

    base_folder = ENV['SANDBOX_FOLDER']

    folder_path = parsed_params["owner"]["login"].to_s
    folder_path = File.join(base_folder, folder_path)

    Dir.mkdir folder_path unless Dir.exist? folder_path

    tests_folder = File.join(base_folder, "tests")
    repo = parsed_params["full_name"].to_s

    labs_h = parsed_params["labs"]
    puts labs_h
    labs_h.each do |lab_id, task_indices|
      lab = Lab.find(lab_id)
      task_indices.each do |index|
        folder_path = File.join(folder_path, "lab#{lab_id}_task#{index}")
        files_folder_path = File.join("lab#{lab_id}", "task#{index}")
        task = lab.tasks.find_by(index_number: index)
        test_file = task.test_filename
        result = task.last_result
        RunTestsJob.perform_later(repo, folder_path, tests_folder, test_file, files_folder_path, result)
      end
    end
    # RunTestsJob.perform_later(repo, folder_path, tests_folder, 'complex_test.rb', 'complex.rb')
  end

  private

  def parse_params
    return nil unless params.has_key?(:payload)

    json = JSON.parse params.require(:payload)

    return nil unless json.has_key?("commits")

    files_set = commited_files json["commits"]
    puts files_set

    labs = labs_hash(files_set)
    json["repository"].merge({ "labs" => labs })
  end

  def commited_files(commited)
    files_set = Set.new
    commited.each do |commit_hash|
      files_set.merge(commit_hash["added"])
      files_set.merge(commit_hash["modified"])
    end
    files_set
  end

  def labs_hash(files_set)
    labs_hash = Hash.new { |hash, key| hash[key] = Array.new }
    files_set.each do |full_path|
      tokens = full_path.split("/")

      raise "must be at least 3 tokens in path" if tokens.length != 3

      key = tokens.first.gsub("lab", "").to_i
      value = tokens[1].gsub("task", "").to_i
      labs_hash[key] << value
    end
    labs_hash
  end
end
