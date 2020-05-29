class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true
  belongs_to :client
  validates :comment, length: {minimum: 2}
  accepts_nested_attributes_for :client # works with 'belongs_to'

  # create virtual attribute as an instance variable
  attr_accessor :client_new
  # Search scopes and class method
  scope :find_by_genre, ->(name) {joins(resto: :genre).where("genres.name ILIKE ?", "%#{name}%")}
  
  scope :find_by_resto, ->(name) {joins(:resto).where("restos.name ILIKE ?", "%#{name}%")}

  include PgSearch::Model
  multisearchable against: :comment
  # needs the counter part in the model Resto
  pg_search_scope :search_by_word, against: [:comment],
  associated_against: {
      resto: :name #association name
    },
    using: {
     tsearch: { prefix: true }
   }
  
  #helper to avoid repeating comments = Comment.find_by_xxx.(query[:x])
  def self.sendmethod(method,query)
    comments = self.send(method, query)
    return  comments.any? ? comments :  self.all
  end

  def self.search_for_comments(query)
    # page load
    return Comment.all if !query.present? || (query.present? && query[:r]=="" && query[:g]=="" && query[:pg]=="") 

    if !(query[:r]== "")
      return self.sendmethod(:find_by_resto, query[:r])

    elsif query[:g] != ""
      return self.sendmethod(:find_by_genre, query[:g])

    elsif query[:pg] != ""
      return self.sendmethod(:search_by_word, query[:pg])
    end
  end
end
