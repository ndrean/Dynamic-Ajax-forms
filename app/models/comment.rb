class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true, inverse_of: :comments
  belongs_to :client
  validates :comment, length: {minimum: 2}

  def self.search_by_resto(query)
    if !query
      return Comment.includes(:resto)
    end
    resto = Resto.find_by(name: query)
    if genre
      self.where(resto_id: resto.id)
    else
      Comment.includes(:resto)
    end
  end

  def self.search_by_genre(query)
    if !query
      return Comment.includes(:resto)
    end
    genre = Genre.find_by(name: query)
    if genre
      self.where(genre_id: genre.id)
    else
      Comment.includes(:resto)
    end
  end
end
