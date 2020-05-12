class Resto < ApplicationRecord
  belongs_to :genre, optional: true
  has_many :comments, dependent: :destroy
  validates :name, uniqueness: true, presence: true
  accepts_nested_attributes_for :comments
end
