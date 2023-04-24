require 'octokit'
require 'base64'
require 'open3'

class RunTestsJob < ApplicationJob
  include WorkingDirHelper
  queue_as :default

  def perform(user, task)
    user_dir = user.setup_user_dir
    working_dir = task.setup_task_dir(user_dir)
    download_files_to_working_dir(user.repo_link, repo_files_dir(task), working_dir)
    test_full_filename = copy_test_file(task.test_filename, working_dir)
    task.run_tests!(test_full_filename, user)
  end
end
