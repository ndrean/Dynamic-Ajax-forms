class RestosController < ApplicationController
  before_action :set_resto, only: [:show, :edit, :update, :destroy]

  # GET /restos
  def index
        logger.debug "....................................INDEX"

    @restos = Resto.all
    @resto = Resto.new
  end

  # GET /restos/1
  def show
    # set_resto
    logger.debug "....................................SHOW"
  end

  # GET /restos/new
  def new
    @resto = Resto.new
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
    @resto = Resto.new(resto_params)
    respond_to do |format|
      if @resto.save
        format.js
        #format.html { redirect_to @resto, notice: 'Resto was successfully created.' }
      else
        format.js
        #format.html { render :new }
      end
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
      params.require(:resto).permit(:name,comments_attributes: [:id, :comment])
    end
end
