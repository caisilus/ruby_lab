class Lab < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :content_path, presence: true
  belongs_to :group
  has_and_belongs_to_many :tasks
  before_destroy { tasks.clear }
end

