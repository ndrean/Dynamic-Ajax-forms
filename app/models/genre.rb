class Genre < ApplicationRecord
    has_many :restos, -> { order(name: :asc)}#, inverse_of: :genre
    has_many :comments, through: :restos
    has_many :clients, through: :comments
    validates :name, uniqueness: true, presence: true
    accepts_nested_attributes_for :restos

    COLORS = []

    include PgSearch::Model
    multisearchable against: :name

end
