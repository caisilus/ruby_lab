class Lab < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :content_path, presence: true
  belongs_to :group
  has_many :tasks
  before_destroy { tasks.clear }

  def index_number
    id + 1
  end
end

