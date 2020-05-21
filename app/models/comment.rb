class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true
  belongs_to :client
  validates :comment, length: {minimum: 2}
  accepts_nested_attributes_for :client

  # Search scopes and class method
  scope :find_by_genre, ->(name) {joins(resto: :genre).where("genres.name ILIKE ?", "%#{name}%")}
  
  scope :find_by_resto, ->(name) {joins(:resto).where("restos.name ILIKE ?", "%#{name}%")}

  include PgSearch::Model
  multisearchable against: :comment

  pg_search_scope :search_by_word, against: [:comment],
  associated_against: {
      resto: :name #association name
    },
    using: {
     tsearch: { prefix: true }
   }
  
  def self.search_for_comments(query)
    # page load
    return Comment.all if !query.present? || (query.present? && query[:r]=="" && query[:g]=="" && query[:pg]=="") 

    if !(query[:r]== "")
      comments = Comment.find_by_resto(query[:r])
      return comments if comments.any?
      return Comment.all
    end

    if query[:g] != ""
      comments = Comment.find_by_genre(query[:g])
      return comments if comments.any?
      return Comment.all
    end

    if query[:pg] != ""
      comments = Comment.search_by_word(query[:pg])
      return comments if comments.any?
      return Comment.all
    end
  end
  
end
