class CommentsController < ApplicationController

  # GET /comments
  def index
    #binding.pry
    @comments = Comment
      .includes(:resto)
      .search_for_comments(params[:search])
      .page(params[:page])
    #.order('restos.name') does not work for the pg_search

    respond_to do |format|
      # Kaminari & search form are AJAX 
      format.js

      # for page load
      format.html
    end
  end
 

  # calls js view for form 'form-comment-resto'
  def new
    @comment = Comment.new
  end

  #if a new client is declared in the form, we create and assign it.
  def create
    @comment = Comment.new(comment_params)

    if params[:comment][:client_new].blank?
      @client = Client.find(params[:comment][:client_id])
    else
      @client = Client.create(name: params[:comment][:client_new])
    end
    
    @comment.client = @client
    
    respond_to do |format|
      @comment.save
      format.js
    end
  end

  # make the form appear in view 'Comments/index'
  def new_resto_on_the_fly
    @resto = Resto.new
    @genres = Genre.all
    
  end
  
  # if a new genre, we create it ('before_save' in model or in the controller)
  def create_resto_on_the_fly
    # method 1 before_save':create_genre_from_resto' in the model

    #method 2 by controller
    # if params[:resto][:new_genre_name].blank?
    #   @genre = Genre.find(params[:resto][:genre_id])
    # else
    #   @genre = Genre.create(name: params[:resto][:new_genre_name])
    # end
    @resto = Resto.new(resto_params)
    # @resto.genre = @genre
    respond_to do |format|
      @resto.save
      format.js
    end
  end

  # PATCH/PUT /comments/1
  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  end

  # DELETE /comments/:id
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:comment, :resto_id, :client_id, :client_new)
    end

    def resto_params
      params.require(:resto).permit(:name, :genre_id, :new_genre_name, genre_attributes: [:name])
    end
end
