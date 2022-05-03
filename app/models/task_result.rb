class TaskResult < ApplicationRecord
  belongs_to :task
  validates  :passed_tests, :total_tests, presence: true

  after_update_commit { broadcast_update }

  def passed_percentage
    passed_tests * 100.0 / total_tests
  end
end

