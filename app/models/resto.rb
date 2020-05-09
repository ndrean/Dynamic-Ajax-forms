class Resto < ApplicationRecord
  belongs_to :genre
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments
  validates :name, uniqueness: true, presence: true
end
