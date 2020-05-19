class Client < ApplicationRecord
    has_many :comments
    has_many :restos, through: :comments
    has_many :genres, through: :comments, source: :resto

end
