class TaskResult < ApplicationRecord
  belongs_to :task
  validates  :passed_tests, :total_tests, presence: true

  # after_update_commit { broadcast_update_later }
  after_create_commit :broadcast_later

  def passed_percentage
    passed_tests * 100.0 / total_tests
  end

  def broadcast_later
    broadcast_replace_later_to(task, :task_results, target: "last_result_task_#{task_id}")
  end
end

