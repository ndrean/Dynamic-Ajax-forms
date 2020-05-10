class CommentsController < ApplicationController

  # GET /comments
  def index
    @comments = Comment.includes([:resto]).page(params[:page])
    respond_to do |format|
      format.js
      format.html
    end
    #@comments = Kaminari.paginate_array(@comments).page(params[:page])
  end

  # GET restos/:id/comments/new
  def new
    logger.debug "...............................NEW COMMENTS"
    @comment = Comment.new
    @resto = Resto.new
    @restos = Resto.all
  end

  # GET restos/:resto_id/comments/:id/edit
  # def edit
  #   logger.debug "...............................EDIT"
  #   @comment = Comment.find(params[:id])
  #   @resto = Resto.new
  # end


  # POST /comments
  def create
    logger.debug "...............................CREATE COMMENT"
    @comment = Comment.new(comment_params)
    respond_to do |format|
      @comment.save
      format.js
    end
  end

  def new_resto_on_the_fly
    logger.debug "...............................NEW FLY"
    @resto = Resto.new
    @genres = Genre.all
  end
  

  def create_resto_on_the_fly
    logger.debug "...............................CREATE FLY"
    @resto = Resto.new(resto_params)
    respond_to do |format|
      @resto.save
      format.js
    end
  end

  # PATCH/PUT /comments/1
  def update
    logger.debug "...............................UPDATE COMM"
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  end

  # DELETE /comments/:id
  def destroy
    logger.debug "...........................DESTROY COMMENT"
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js
      #format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Strong params, only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:comment,  :resto_id)
    end

    def resto_params
      params.require(:resto).permit(:name, :genre_id)
    end
end
