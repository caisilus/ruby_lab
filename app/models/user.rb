class User < ApplicationRecord
  validates :github_login, presence: true, uniqueness: true
  validates :name, presence: true
  validates :surname, presence: true
  validates :avatar_url, presence: true
end
