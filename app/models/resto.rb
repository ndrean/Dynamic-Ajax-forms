class Resto < ApplicationRecord
  belongs_to :genre, optional: true #, inverse_of: :restos : NO EFFECT
  has_many :comments, dependent: :destroy
  has_many :clients, through: :comments
  validates :name, uniqueness: true, presence: true
  accepts_nested_attributes_for :comments
  #acts_as_taggable_on :notes


  scope :find_by_genre, ->(name) {joins(:genre).where("genres.name ILIKE ?", "%#{name}%")}

  # for the 'search_by_word' pg method in comments
  include PgSearch::Model
  multisearchable against: :name

  def self.search(query)
    # for page load where query = nil and clic on search for refresh
    return Resto.all if !query || (query[:g] == "" && query[:r]=="")
    
    if !(query[:g] == "")
      genre = self.find_by_genre(query[:g])
      return genre if genre.any?
      return Resto.all

    elsif query[:r] != ""
      restos = self.where("restos.name ILIKE ?", "%#{query[:r]}%")
      return restos if restos.any?
      return Resto.all
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