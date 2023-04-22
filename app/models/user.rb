class User < ApplicationRecord
  validates :github_login, presence: true, uniqueness: true
  validates :name, presence: true
  validates :surname, presence: true
  validates :avatar_url, presence: true

  def full_name
    return [surname, name].join(" ") if self.middle_name.nil?

    [surname, name, middle_name].join(" ")
  end

  def github_profile_link
    "https://github.com/#{github_login}"
  end
end
