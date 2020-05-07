class CommentsController < ApplicationController
  #before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.includes([:resto])
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])
  end

  # GET restos/:id/comments/new
  def new
    @comment = Comment.new
    @resto = Resto.new
    @restos = Resto.all
  end

  # GET restos/:id/comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @resto = Resto.new
  end


  # POST /comments
  # POST /comments.json
  def create
    #@resto = Resto.new(comment_params)
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save #&& @resto.save
        format.js
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def newResto
    @resto = Resto.new
    respond_to do |format|
      format.js
    end
  end
  
  def create_resto
    @resto = Resto.new(resto_params)
    respond_to do |format|
      if @resto.save
        format.js
      else
        format.js
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
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
      params.require(:resto).permit(:name)
    end
end
