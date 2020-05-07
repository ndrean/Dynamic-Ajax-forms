class RestosController < ApplicationController
  before_action :set_resto, only: [:show, :edit, :update, :destroy]

  # GET /restos
  def index
    @restos = Resto.all
    @resto = Resto.new
  end

  # GET /restos/1
  def show
    # set_resto
  end

  # GET /restos/new
  def new
    @resto = Resto.new
  end

  # GET /restos/1/edit
  def edit
    # set_resto
  end

  # POST /restos
  def create
    @resto = Resto.new(resto_params)
    respond_to do |format|
      if @resto.save
        format.js
        format.html { redirect_to @resto, notice: 'Resto was successfully created.' }
        format.json { render :show, status: :created, location: @resto }
      else
        format.js
        format.html { render :new }
        format.json { render json: @resto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restos/1
  # PATCH/PUT /restos/1.json
  def update
    #set_resto
    respond_to do |format|
      if @resto.update(resto_params)
        format.html { redirect_to @resto, notice: 'Resto was successfully updated.' }
        format.json { render :show, status: :ok, location: @resto }
      else
        format.html { render :edit }
        format.json { render json: @resto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restos/:id : before_action 'set_resto': @resto = Resto.find(params[:id])
  def destroy
    # set_resto
    #@resto.comments.destroy_all
    @resto.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to restos_url, notice: 'Resto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resto
      @resto = Resto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resto_params
      params.require(:resto).permit(:name)
    end
end
