class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true
  validates :comment, length: {minimum: 2}
end
