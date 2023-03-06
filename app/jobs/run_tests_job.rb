require 'octokit'
require 'base64'
require 'open3'

class RunTestsJob < ApplicationJob
  queue_as :default

  def perform(repo, user_folder, tests_folder, test_file, files_folder_path, result)
    prepare_directory user_folder

    contents = get_folder_contents_list(repo, files_folder_path)
    contents.each do |content|
      write_decoded_content content[:content], File.join(user_folder, content[:name])
    end

    user_tests_folder = copy_tests tests_folder, user_folder

    gem_file_path = File.join(Dir.home, ENV['SANDBOX_FOLDER'], 'Gemfile')
    run_result = run_test_file(File.join(user_tests_folder, test_file), gem_file_path=gem_file_path)

    result.total_tests = run_result["total"]
    result.passed_tests = run_result["passed"]
    result.save
  end

  private

  def get_folder_contents_list(repo, path)
    response = Octokit.contents(repo, options = { path: path })
    if response.is_a?(Array)
      contents = []
      response.each do |obj|
        raise "No type field" unless obj.key? :type

        if obj[:type] == "file"
          obj_responce = Octokit.contents(repo, options = { path: obj[:path] })
          contents << obj_responce
        end
      end
    else
      contents = [response]
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
      res, _status = Open3.capture2('subo', '-u', sandbox_user, 'bundle', 'exec', 'ruby', test_file)
    else
      # res = `bundle exec ruby #{test_file}`
      res, _status = Open3.capture2('bundle', 'exec', 'ruby', test_file)
    end

    res = JSON.parse res
    res["statistics"]
  end
end
