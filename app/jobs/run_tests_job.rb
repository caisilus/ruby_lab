require 'octokit'
require 'base64'
require 'open3'

class RunTestsJob < ApplicationJob
  queue_as :default

  def perform(repo, user_dir, tests_dir, test_file, files_dir, result)
    prepare_directory user_dir

    download_files_to_user_dir(user_dir, repo, files_dir)

    user_tests_dir = copy_tests tests_dir, user_dir

    run_result = run_test_file(File.join(user_tests_dir, test_file))

    result.total_tests = run_result["total"]
    result.passed_tests = run_result["passed"]
    result.save
  end

  private

  def download_files_to_user_dir(user_dir, repo, files_dir)
    contents = get_dir_contents_list(repo, files_dir)
    contents.each do |content|
      write_decoded_content content[:content], File.join(user_dir, content[:name])
    end
  end

  def get_dir_contents_list(repo, dir_path)
    response = Octokit.contents(repo, options = { path: dir_path })

    return [response] unless response.is_a?(Array)

    contents = []
    response.each do |content_data|
      next unless content_data.key?(:type) && content_data[:type] == "file"

      obj_responce = Octokit.contents(repo, options = { path: content_data[:path] })
      contents << obj_responce
    end

    contents
  end

  def prepare_directory(dir_path)
    FileUtils.rm_rf(dir_path) if Dir.exist? dir_path

    Dir.mkdir(dir_path)
  end

  def write_decoded_content(encoded, filename)
    decoded = Base64.decode64(encoded).force_encoding('utf-8')
    File.open(filename, 'w') do |file|
      file.write(decoded)
    end
  end

  def copy_tests(tests_folder, destination_folder)
    res_folder = File.join(destination_folder, "tests")

    FileUtils.cp_r File.join(tests_folder, "."), res_folder

    res_folder
  end

  # returns json with fields total, failed, errored, skipped, passed
  def run_test_file(test_file, sandbox_user: nil)
    if sandbox_user
      #res = `sudo -u #{sandbox_user} bundle exec ruby #{test_file}"`
      res, _status = Open3.capture2('sudo', '-u', sandbox_user, 'bundle', 'exec', 'ruby', test_file)
    else
      # res = `bundle exec ruby #{test_file}`
      res, _status = Open3.capture2('bundle', 'exec', 'ruby', test_file)
    end

    res = JSON.parse res
    res["statistics"]
  end
end
