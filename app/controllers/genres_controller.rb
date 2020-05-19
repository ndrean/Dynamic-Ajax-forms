class GenresController < ApplicationController

around_action :rescue_from_fk_contraint, only: [:destroy]

  def new
    @genre = Genre.new
    respond_to do |format|
      format.js
    end
  end

  def index
    @genres = Genre.includes([:restos]) # ordered in the model
    @genre = Genre.new # creation of Genre
    @resto = Resto.new # for the patch @resto.genre
    @restos = Resto.all
  end


  def create
    #logger.debug "..........................................CREATE GENRE"
    @genre = Genre.new(genres_params)
    #byebug
    respond_to do |format|
      @genre.save
      format.js
     #{ render @genre.errors } # for the debug in the logs
    end
  end

  def set_genre_to_resto
    #logger.debug "..........................................MOVE"
    @resto = Resto.find(resto_params[:id])
    respond_to do |format|
      @resto.update(resto_params)
      @genre_after = @resto.genre
      format.js
    end
  end

  def update
    #logger.debug ".................................................UPDATE.."
    genre = Genre.find(params[:id])
    #byebug
    if genre.update(genres_params)
      render json: { status: :ok}
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def destroy
    #logger.debug ".................................................DESTROY.."
    @genre = Genre.find(params[:id])
    respond_to do |format|
      @genre.destroy
      format.js
    end
  end

  def deleteFetch
    #logger.debug "...............................DESTROY.."
    @genre = Genre.find(params[:id])
    if @genre.destroy
      render json: {status: :ok}
    else
        render json: {status: :unprocessable_entity}
    end
  end

  private
  def resto_params
    params.require(:resto).permit(:name, :id, :genre_id)
  end

  def genres_params
    params.require(:genre).permit(:name, :id)
  end

  def rescue_from_fk_contraint
    begin
      yield
    rescue ActiveRecord::InvalidForeignKey
      render json: {error: :unprocessable_entity} 
    end
  end
  
end
