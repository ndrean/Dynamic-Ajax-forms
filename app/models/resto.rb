class Resto < ApplicationRecord
  belongs_to :genre, optional: true #, inverse_of: :restos : NO EFFECT
  has_many :comments, dependent: :destroy
  has_many :clients, through: :comments
  validates :name, uniqueness: true, presence: true
  accepts_nested_attributes_for :comments

  scope :find_by_genre, ->(name) {joins(:genre).where("genres.name ILIKE ?", "%#{name}%")}

  def self.search_by_genre(query)
    # for page load where query = nil
    if !query
      return Resto.all
    end
    # wildcard or blank since 'required:false' in the html
    if query[:q] == "" && query[:r]==""
      return Resto.all
    end
    if query[:q] != ""
      genre = Genre.where("genres.name ILIKE ?", "%#{query[:q]}%")
      if genre.any?
       logger.debug ".........................GENRE"
        return self.joins(:genre).merge(genre)
      end
    elsif query[:r] != ""
      logger.debug ".........................SEE IF RESTO"
      restos = self.where("restos.name ILIKE ?", "%#{query[:r]}%")
      logger.debug ".........................#{restos}"
      if restos.any?
        logger.debug ".........................RESTO"
        return restos
      end
    else
       logger.debug ".........................HERE"
      Resto.all
    end
  end
end

# method overrides 'save' to catch the database error before bubbles to user interface
  # def save(*args)
  #   super
  # rescue  ActiveRecord::RecordNotUnique => error
  #   errors[:base] << error.message
  #   false
  # end