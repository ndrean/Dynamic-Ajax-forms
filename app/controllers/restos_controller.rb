class RestosController < ApplicationController
  before_action :set_resto, only: [:show, :edit, :update, :destroy]

  layout proc { false if request.xhr? }

  def index
    @restos = Resto.order(name: :asc).includes([:genre]).search(params[:search]).page(params[:page])  

    respond_to do |format|
      # Kaminari pagination and form response is 'remote: true'
      format.js 

      # for fetch() 'GET/restos?search + URLSearchParams(new FormData(e.target)).toString()'
      format.json { render json: @restos.to_json} 
      
      # we need this one for the first render on page load
      format.html
      # then we put 'remote: true' in the form, rendered is 'format.js'
    end
  end

  # add a form with dynamic addition of comments
  def new
    @resto = Resto.new
    @genres = Genre.all
    @clients = Client.all
    @resto.comments.build.build_client
    respond_to :js
  end

  # POST
  def create
    binding.pry
    @resto = Resto.new(resto_params)
    respond_to do |format|
      @resto.save
      format.js
    end
  end

  # PATCH genre/:id : endpoint for fetch()-patch for updating resto.genre in drag&drop
  def updateGenre
    resto_params = params.require(:resto).permit(:genre_id, :id)
    @resto = Resto.find(params[:id])
    if @resto.update(resto_params)
      render json: {status: :ok}
    else
      render json: {success: false, errors: @resto.erros.messages}, status: :unprocessable_entity
    end
  end
  
  def update
    #@resto = Resto.find(params[:id])  <=> set_resto
    @resto.update(resto_params)
  end

  # delete /restos/:id
  def destroy
    @resto = Resto.includes(comments: :pg_search_document).find(params[:id])  #<=> set_resto
    #@resto.comments.destroy_all <=> dependent: :destroy in the model
    @resto.destroy
  end

  private
    def set_resto
      @resto = Resto.find(params[:id])
    end

    def resto_params
      params.require(:resto).permit(:name,:genre_id,
        comments_attributes: [:comment, :client_id
          #client_attributes: [:id
          #]
        ]
      )
    end
end
