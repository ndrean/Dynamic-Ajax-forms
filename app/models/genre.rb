class Genre < ApplicationRecord
  has_many :restos
  validates :name, presence: true, uniqueness: true
end
