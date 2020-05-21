class GenresController < ApplicationController

  def new
    @genre = Genre.new
    respond_to do |format|
      format.js
    end
  end

  def new4
    @genre = Genre.new
    @genre.restos.build.comments.build.build_client
  end

  def index
    @genres = Genre.includes([:restos]) # ordered in the model
    @genre = Genre.new # creation of Genre
    @resto = Resto.new # for the patch @resto.genre
    @restos = Resto.all
  end

  def create4
    @genre = Genre.new(nest_params)
    #binding.pry
    if !@genre.save
      render :new4
    end
  end

  def create
    logger.debug "..........................................CREATE GENRE"
    @genre = Genre.new(genres_params)
    #byebug
    respond_to do |format|
      @genre.save
      format.js
     #{ render @genre.errors } # for the debug in the logs
    end
  end

  # called by form 'Select resto and assign a type and responds by move in the DOM'
  def set_genre_to_resto
    logger.debug "..........................................MOVE BY ASSIGN IN FORM"
    @resto = Resto.find(resto_params[:id])
    respond_to do |format|
      @resto.update(resto_params)
      @genre_after = @resto.genre
      format.js #{ render @genre.errors } # for the debug in the logs
    end
  end

  def update
    logger.debug ".................................................UPDATE GENRE.."
    genre = Genre.find(params[:id])
    if genre.update(genres_params)
      render json: { status: :ok}
    else
      render json: { status: :unprocessable_entity }
    end
  end

  # destroy via standard 'link_to'
  def destroy
    logger.debug ".................................................DESTROY.."
    @genre = Genre.find(params[:id])
    respond_to do |format|
      @genre.destroy
      format.js
    end
  end

  # endpoint for 'fetch()' method delete
  def deleteFetch
    logger.debug "...............................DELETEFETCH.."
    @genre = Genre.find(params[:id])
    if @genre.destroy
      render json: {status: :ok}
    else
        render json: {status: :unprocessable_entity}
    end
  end

  private
  def resto_params
    params.require(:resto).permit(:id, :genre_id)
  end

  def genres_params
    params.require(:genre).permit(:name, :id)
  end

  def nest_params
    params.require(:genre).permit(:name,
       restos_attributes: [:name,
         comments_attributes:[:comment, 
          client_attributes: [:name]
        ]
      ]
    )
  end

end

# see rescue_from_fk_contraint'