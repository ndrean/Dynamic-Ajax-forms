class Comment < ApplicationRecord
  belongs_to :resto
  validates :comment, length: {minimum: 2}
end
