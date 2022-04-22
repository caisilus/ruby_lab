class TaskResult < ApplicationRecord
  belongs_to :task
  validates  :passed_tests, :total_tests, presence: true

  def passed_percentage
    passed_tests * 100.0 / total_tests
  end
end

