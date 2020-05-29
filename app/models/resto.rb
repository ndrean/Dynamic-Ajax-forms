class Resto < ApplicationRecord
  belongs_to :genre, optional: true#, inverse_of: :restos # TEST ON QUERIES
  has_many :comments, dependent: :destroy
  has_many :clients, through: :comments
  validates :name, uniqueness: true, presence: true
  accepts_nested_attributes_for :comments

  ##### 
  # create virtual attribute as an instance variable to pass a value
  # and 'belongs_to' gives the method 'create_genre'
  attr_accessor :new_genre
  before_save :create_genre_from_resto
  def create_genre_from_resto
    create_genre(name: new_genre ) unless new_genre.blank?
  end
  ######

  scope :find_by_genre, ->(name) {joins(:genre).where("genres.name ILIKE ?", "%#{name}%")}

  # for the 'search_by_word' pg method in comments
  include PgSearch::Model
  multisearchable against: :name

  def self.search(query)
    # for page load where query = nil and clic on search for refresh
    return Resto.all if !query || (query[:g] == "" && query[:r]=="")
    
    if !(query[:g] == "")
      restos_by_genre = self.find_by_genre(query[:g])
      return restos_by_genre.any? ? restos_by_genre : Resto.all
      

    elsif query[:r] != ""
      restos_by_name = self.where("restos.name ILIKE ?", "%#{query[:r]}%")
      return restos_by_name.any? ? restos_by_name : Resto.all
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