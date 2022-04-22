class Task < ApplicationRecord
  validates :title, :content_path, presence: true
  has_rich_text :text
  has_and_belongs_to_many :labs
  has_many :task_results
  before_destroy { labs.clear }

  def last_result
    task_results.last
  end
end

