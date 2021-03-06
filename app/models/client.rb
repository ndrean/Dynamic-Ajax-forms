class Client < ApplicationRecord
    has_many :comments#, inverse_of: :client
    has_many :restos, through: :comments
    has_many :genres, through: :comments, source: :resto
    validates :name, uniqueness: true

end
