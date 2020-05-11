class GenresController < ApplicationController
  # def new
  # end

  def index
    @genres = Genre.includes([:restos])
    @genre = Genre.new
    @resto = Resto.new
    @restos = Resto.all
  end

  def dnd
    @genres = Genre.includes([:restos])
    respond_to do |format|
      format.js
    end
  end

  def create
    logger.debug "..........................................CREATE GENRE"
    @genre = Genre.new(genres_params)
    respond_to do |format|
      @genre.save
      format.js
    end
  end

  def set_genre_to_resto
    @resto = Resto.find(resto_params[:id])
   
    respond_to do |format|
      @resto.update(resto_params)
      @genre_after = @resto.genre
      format.js
    end
  end


  # def set_genre_to_restos
  #   logger.debug "..........................................SET GENRES TO RESTO"
  #   @var = restos_genres_params
  #   raise
  #   #@list_restos = 
  # end

  def fetch_create
    @genre = Genre.new(genres_params)
    logger.debug "..........................................FETCH CREATE"
    @genres = Genre.all
    if @genre.save
      render json: @genre, status: :ok # Rails automatically call .to_json after :json option
    end
  end

  def destroy
    logger.debug ".................................................DESTROY..#{@genre.name}"
    @genre = Genre.find(params([:id]))
    if @genre.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  def fetch_delete
    @genre = Genre.find(params([:id]))
    logger.debug "...................................................FETCH DELETE.. #{@genre.name} #{@genre.id}"
    if @genre.delete
      head :no_content, status: :ok
    end
  end

  private
  # def resto_genre_params
  #   params.require
  # end

  def restos_genres_params
    params.require(:q).permit(list_names: [:resto_id], genre: [:genre_id])
  end

  def resto_params
    params.require(:resto).permit(:name, :id, :genre_id)
  end

  def genres_params
    params.require(:genre).permit(:name)
  end

end
