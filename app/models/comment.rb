class Comment < ApplicationRecord
  belongs_to :resto
  # we override the field name by using a symbol instead of true as the value for the counter_cache option
  validates :comment, length: {minimum: 2}
end