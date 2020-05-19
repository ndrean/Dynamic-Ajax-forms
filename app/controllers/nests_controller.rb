class NestsController < ApplicationController
  
  def new
    @genre = Genre.new
    @genre.restos.build.comments.build

    @genre_first = Genre.first

    @restof = Resto.new(genre: @genre_first)
    

    @genre_new = Genre.new
  end

  # for triple nested
  def create
    genre = Genre.new(nest_params)
    if genre.save
      redirect_to restos_path
    else
      render :new
    end
  end

  
  def create_genre
    Genre.create(genre_params)
  end

  def create_resto
    @resto = Resto.create(resto_params)
  end

  def update_genre
    @genre = Genre.create(genre_params)
  end

  private
  def nest_params
    params.require(:genre).permit(:name,
       restos_attributes: [:name,
         comments_attributes:[:comment]])
  end

  def resto_params
    params.require(:resto).permit(:name, :genre_id)
  end

  def genre_params
    params.require(:genre).permit(:name,:id)
  end

end
