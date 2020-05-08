class CommentsController < ApplicationController
  #before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  def index
    @comments = Comment.includes([:resto])
  end

  # GET restos/:resto_id/comments/:id
  def show
    @comment = Comment.find(params[:id])
  end

  # GET restos/:id/comments/new
  def new
    logger.debug "...............................NEW COMMENTS"
    @comment = Comment.new
    @resto = Resto.new
    @restos = Resto.all
  end

  # GET restos/:resto_id/comments/:id/edit
  def edit
    @comment = Comment.find(params[:id])
    @resto = Resto.new
  end


  # POST /comments
  def create
    logger.debug "...............................CREATE COMMENT"
    #@resto = Resto.new(comment_params)
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save #&& @resto.save
        format.js
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def new_resto_on_the_fly
    logger.debug "...............................NEW RESTO FROM COMMENTS"
    @resto = Resto.new
    # respond_to do |format|
    #   format.js
    # end
  end
  

  def create_resto_on_the_fly
    logger.debug "...............................CREATE RESTO FROM COMMENTS"
    @resto = Resto.new(resto_params)
    respond_to do |format|
      if @resto.save
        format.js { flash[:notice]= "Restaurant created"}
      else
        format.js { flash[:notice]= "Error"}
      end
    end
  end

  def save_edit
    @comment = Comment.find(params[:id])
    raise
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /comments/1
  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    # respond_to do |format|
      
    # end
  end

  # DELETE /comments/:id
  def destroy
    logger.debug "...........................;DESTROY COMMENT"
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
      params.require(:resto).permit(:name)
    end
end
