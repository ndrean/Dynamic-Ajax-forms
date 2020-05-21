class CommentsController < ApplicationController

  # GET /comments
  def index
    #binding.pry
    @comments = Comment
      .includes(:resto)
      .search_for_comments(params[:search])
      .page(params[:page])
      #.order('restos.name')

    respond_to do |format|
      format.js
      format.html #{ render partial: 'comments/table_comments', comments:@comments, layout: false}
    end
  end

    # if params[:search].present?
    #   if params[:search][:r]!= ""
    #     logger.debug ".................................R"
    #     comments = Comment.find_by_resto(params[:search][:r])
    #     if comments != []
    #       logger.debug ".................................R NOT EMPTY"
    #       @comments = comments.includes(:resto).page(params[:page])
    #     else
    #       logger.debug ".................................ALL R"
    #       @comments = comments.includes(:resto).page(params[:page])
    #     end
    #   elsif params[:search][:g] != ""
    #     logger.debug ".................................G"
    #     comments = Comment.find_by_genre(params[:search][:g])
    #     if comments != []
    #       logger.debug ".................................G NOT EMPTY"
    #       @comments = comments.includes(:resto).page(params[:page])
    #     # else
    #     #   logger.debug ".................................ALL G"
    #     #   @comments = Comment.includes([:resto]).page(params[:page])
    #     end
    #   elsif params[:search][:pg] != ""
    #     logger.debug ".................................PG"
    #     comments = Comment.search_by_word(params[:search][:pg])
    #     if comments != []
    #       logger.debug ".................................PG NOT EMPTY"
    #       @comments = comments.page(params[:page])
    #     else
    #       logger.debug ".................................ALL PG"
    #       @comments = Comment.includes([:resto]).page(params[:page])
    #     end
    #   else
    #     logger.debug "..................................END..."
    #     @comments = Comment.all.includes(:resto).page(params[:page])
    #   end
    # else
    #   @comments = Comment.all.includes(:resto).order('restos.name').page(params[:page])
    # end

    

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
