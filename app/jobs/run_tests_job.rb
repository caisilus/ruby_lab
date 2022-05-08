require 'octokit'
require 'base64'

class RunTestsJob < ApplicationJob
  queue_as :default

  def perform(repo, user_folder, tests_folder, test_file, *filenames)
    prepare_directory user_folder

    filenames.each do |filename|
      content = Octokit.contents(repo, options = { path: filename })

      write_decoded_content content[:content], File.join(user_folder, filename)
    end

    user_tests_folder = copy_tests tests_folder, user_folder

    gem_file_path = File.join(Dir.home, ENV['SANDBOX_FOLDER'], 'Gemfile')
    run_test_file File.join(user_tests_folder, test_file), gem_file_path=gem_file_path
  end

  private

  def prepare_directory(dir_path)
    FileUtils.rm_rf(dir_path) if Dir.exist? dir_path

    Dir.mkdir(dir_path)
  end

  def write_decoded_content(encoded, filename)
    decoded = Base64.decode64(encoded)
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
  def run_test_file(test_file, gem_file_path='', sandbox_user: nil)
    if sandbox_user
      res = system("sudo -u #{sandbox_user} bundle exec ruby #{test_file}")
    else
      system("bundle exec ruby #{test_file}")
      res = gets
    end

    res = JSON.parse res
    puts res[:statistics]
    res[:statistics]
  end
end
