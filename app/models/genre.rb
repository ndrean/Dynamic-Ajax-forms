class Genre < ApplicationRecord
    has_many :restos, -> { order(name: :asc)}
    validates :name, uniqueness: true, presence: true
    accepts_nested_attributes_for :restos

    COLORS = []
end
