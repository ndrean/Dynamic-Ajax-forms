class Genre < ApplicationRecord
    has_many :restos
    validates :name, uniqueness: true, presence: true
end
