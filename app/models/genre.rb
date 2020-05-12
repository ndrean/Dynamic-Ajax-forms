class Genre < ApplicationRecord
    has_many :restos
    validates :name, uniqueness: true, presence: true
    accepts_nested_attributes_for :restos

    COLORS = []
end
