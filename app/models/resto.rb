class Resto < ApplicationRecord
  belongs_to :genre
  has_many :comments
end
