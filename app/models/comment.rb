class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true
  # requires a field comments_count to the Resto model
  validates :comment, length: {minimum: 2}
end