class TaskResult < ApplicationRecord
  include LastResultHelper
  belongs_to :task
  belongs_to :user
  validates  :passed_tests, :total_tests, presence: true

  after_create_commit :broadcast_later

  def passed_percentage
    passed_tests * 100.0 / total_tests
  end

  def broadcast_later
    chanel_name = last_result_dom_id(task, user)
    broadcast_update_later_to(chanel_name, target: chanel_name)
  end
end

