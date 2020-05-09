class GenresController < ApplicationController
  def new
    @genre = Genre.new
  end

  
  def create
    @genre = Genre.new(genres_params)
    @genre.save
  end

  def delete
  end

  private
  def genres_params
    params.require(:genre).permit(:name)
  end
end
