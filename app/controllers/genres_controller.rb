class GenresController < ApplicationController
  # def new
  # end

  def index
    @genres = Genre.includes([:restos])
    @genre = Genre.new # creation of Genre
    @resto = Resto.new # for the patch @resto.genre
    @restos = Resto.all
  end


  def create
    logger.debug "..........................................CREATE GENRE"
    @genre = Genre.new(genres_params)
    respond_to do |format|
      if @genre.save
        format.js
        format.html
      else
        raise
        format.js
      end
    end
  end

  def set_genre_to_resto
    logger.debug "..........................................MOVE"
    @resto = Resto.find(resto_params[:id])
    respond_to do |format|
      @resto.update(resto_params)
      @genre_after = @resto.genre
      format.js
    end
  end

  # def fetch_create
  #   @genre = Genre.new(genres_params)
  #   @genres = Genre.all
  #   if @genre.save
  #     render json: @genre, status: :ok # Rails automatically call .to_json after :json option
  #   end
  # end

  def destroy
    logger.debug ".................................................DESTROY.."
    @genre = Genre.find(params[:id])
    
    
    respond_to do |format|
      if @genre.destroy
        format.js
        #head :no_content, status: :ok
      else
        format.js
      end
    end
  end

  def deleteFetch
    @genre = Genre.find(params[:id])
    logger.debug "...................................................FETCH DELETE.. #{@genre.name} #{@genre.id}"
    if @genre.delete
      render json: {status: :ok}
    end
  end

  private
  # def resto_genre_params
  #   params.require
  # end

  # def restos_genres_params
  #   params.require(:q).permit(list_names: [:resto_id], genre: [:genre_id])
  # end

  def resto_params
    params.require(:resto).permit(:name, :id, :genre_id)
  end

  def genres_params
    params.require(:genre).permit(:name, :id)
  end

end
