class User < ApplicationRecord
  validates :github_login, presence: true, uniqueness: true
  validates :name, presence: true
  validates :surname, presence: true
  validates :avatar_url, presence: true
  validates :repo_link, presence: true
  has_many :task_results, dependent: :destroy

  def full_name
    return [surname, name].join(" ") if self.middle_name.nil?

    [surname, name, middle_name].join(" ")
  end

  def github_profile_link
    "https://github.com/#{github_login}"
  end

  def setup_user_dir
    base_dir = ENV["SANDBOX_DIRECTORY"]
    user_dir = File.join(base_dir, github_login)

    Dir.mkdir(user_dir) unless Dir.exist?(user_dir)

    user_dir
  end
end
