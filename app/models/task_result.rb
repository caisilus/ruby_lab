class TaskResult < ApplicationRecord
  include LabsHelper
  belongs_to :task
  belongs_to :user
  validates  :passed_tests, :total_tests, presence: true

  after_create_commit :broadcast_later

  def passed_percentage
    passed_tests * 100.0 / total_tests
  end

  def broadcast_later
    target = last_result_dom_id(task, user)
    broadcast_update_later_to(task, :task_results, target: target)
  end
end

