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
      format.js
      format.html #{render 'comments/table_comments', comments: @comments }
    end
  end
 

  # calls js view for form 'form-comment-resto'
  def new
    @comment = Comment.new
    @resto = Resto.new
  end

  

  # POST /comments
  def create
    #logger.debug "...............................CREATE COMMENT"
    @comment = Comment.new(comment_params)
    respond_to do |format|
      @comment.save
      format.js
    end
  end

  # make the form appear in view 'Comments/index'
  def new_resto_on_the_fly
    # logger.debug "...............................NEW FLY"
    @resto = Resto.new
    @genres = Genre.all
  end
  
  # updates the select field in the form 'new comment'
  def create_resto_on_the_fly
    # logger.debug "...............................CREATE FLY"
    @resto = Resto.new(resto_params)
    respond_to do |format|
      @resto.save
      format.js
    end
  end

  # PATCH/PUT /comments/1
  def update
    #logger.debug "...............................UPDATE COMM"
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  end

  # DELETE /comments/:id
  def destroy
    # logger.debug "...........................DESTROY COMMENT"
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
      params.require(:comment).permit(:comment, :resto_id)
    end

    def resto_params
      params.require(:resto).permit(:name, :genre_id)
    end
end
