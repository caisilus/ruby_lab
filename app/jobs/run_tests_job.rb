require 'octokit'
class RunTestsJob < ApplicationJob
  queue_as :default

  def perform(repo, folder_path, tests_folder)
    Dir.rmdir folder_path if Dir.exist? folder_path

    Dir.mkdir(folder_path)

    content = Octokit.contents(repo, options = { path: "complex.rb" })
    puts content[:download_url]
    FileUtils.cp_r File.join(tests_folder, "."), File.join(folder_path, "tests")
  end
end
