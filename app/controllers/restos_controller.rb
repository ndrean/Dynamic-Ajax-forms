class RestosController < ApplicationController
  before_action :set_resto, only: [:show, :edit, :update, :destroy]

  # GET /restos
  def index
    logger.debug "....................................INDEX"
    #@restos = Resto.all
    @restos = Resto.includes([:genre]).page(params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /restos/1
  # def show
  #   # set_resto
  #   logger.debug "....................................SHOW"
  # end

  # GET /restos/new
  def new
    logger.debug " ..................................................NEW" 
    @resto = Resto.new
    @genres = Genre.all
    @resto.comments.build
    respond_to do |format|
      format.js
    end
  end

  # GET /restos/1/edit
  #def edit
    #@resto = Resto.find(params[:id])  <=> set_resto
    #logger.debug "...........................................EDIT"
  #end

  # POST /restos
  def create
    logger.debug " ..................................................CREATE RESTO" 
    @resto = Resto.new(resto_params)
    respond_to do |format|
      @resto.save
      format.js
    end
  end

  def updateGenre
    logger.debug "..........................................POST UPDATE"
    data = params.require(:resto).permit(:genre_id, :id)
    resto = Resto.find(params[:resto][:id])
    if resto.update(data)
      render json: {status: :ok}
    else
        render json: {status: :unprocessable_entity}
    end
  end
  
  

  # PATCH/PUT /restos/1
  def update
    #@resto = Resto.find(params[:id])  <=> set_resto
    logger.debug " ..................................................UPDATE #{@resto.id}" 
    #raise params.inspect
    @resto.update(resto_params)
  end

  # DELETE /restos/:id
  def destroy
    logger.debug " ..................................................KILL" 
    #@resto = Resto.find(params[:id])  <=> set_resto
    #@resto.comments.destroy_all <=> dependent: :destroy in the model
    @resto.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resto
      @resto = Resto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resto_params
      params.require(:resto).permit(:name,:genre_id, comments_attributes: [:id, :comment])
    end
end
