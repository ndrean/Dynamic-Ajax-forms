class RestosController < ApplicationController
  before_action :set_resto, only: [:show, :edit, :update, :destroy]

  def index
    # @restos = Resto.all
    #byebug
    @restos = Resto.order(name: :asc).includes([:genre]).search_by_genre(params[:search]).page(params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  # add a form with dynamic addition of comments
  def new
    @resto = Resto.new
    @genres = Genre.all
    @resto.comments.build
    respond_to do |format|
      format.js
    end
  end

  # POST
  def create
    @resto = Resto.new(resto_params)
    respond_to do |format|
      @resto.save
      format.js
    end
  end

  # PATCH genre/:id
  def updateGenre
    data = params.require(:resto).permit(:genre_id, :id)
    resto = Resto.find(params[:resto][:id])
    if resto.update(data)
      render json: {status: :ok}
    else
        render json: {status: :unprocessable_entity}
    end
  end
  
  def update
    #@resto = Resto.find(params[:id])  <=> set_resto
    #logger.debug " ..................................................UPDATE #{@resto.id}" 
    #raise
    @resto.update(resto_params)
  end

  # delete /restos/:id
  def destroy
    #@resto = Resto.find(params[:id])  <=> set_resto
    #@resto.comments.destroy_all <=> dependent: :destroy in the model
    @resto.destroy
  end

  private
    def set_resto
      @resto = Resto.find(params[:id])
    end

    def resto_params
      params.require(:resto).permit(:name,:genre_id, :search, comments_attributes: [:id, :comment])
    end
end
