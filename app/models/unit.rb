class Unit < ApplicationRecord
  validates :name, presence: true, uniqueness: true, allow_nil: false, allow_blank: false
  has_many :labs
end
