require 'octokit'
require 'base64'
require 'open3'

class RunTestsJob < ApplicationJob
  queue_as :default

  def perform(username, repo, task)
    task.run_tests!(username, repo)
  end
end
