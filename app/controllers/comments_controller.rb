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
    if params[:comment][:client_new] != ""
      @comment.client = Client.find_or_create_by(name: params[:comment][:client_new])
    end

    # Note l2 is EQUIVALENT to:
    # if params[:comment][:client_new].blank?
    #   @client = Client.find(params[:comment][:client_id])
    # else
    #   @client = Client.create(name: params[:comment][:client_new])
    # end
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
    # method 1 before_save':create_genre_from_resto' in the mode

    
    @resto = Resto.new(resto_params)
    # method 2:
    # if params[:resto][:new_genre].blank?
    #   @genre = Genre.find(params[:resto][:genre_id])
    # else
    #   @genre = Genre.create(name: params[:resto][:new_genre])
    # end
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
  #################### TESTING 
  # GOTO to /comments/display
  # example of using a form to display an existing item
  # def display
  #   # form1 is populated with a new genre ready to by filled
  #   @genre = Genre.new

  #   # populate form2 with a given item
  #   @genre1 = Genre.first
  #   # we save the id through a session variable for the update method
  #   session['g1_id'] = @genre1.id

  #   # pass an id 'by hand' in the query string (after looking for one in Rails console),
  #   # and form 3 will be populated with it since we declare route 'genres/:id, to 'comments/display'
  #   # if params[:id]
  #   #   @genre2 = Genre.find(params[:id])
  #   # # save id for next step
  #   #   session['g2_id'] = params[:id]
  #   # else
  #   #   @genre2 = Genre.new
  #   # end
  # end

  # POST GENRE (cf routes)
  # def save_display
  #   genre = Genre.new(genre_params)
  #   genre.save
  #   redirect_to :root
  # end

  # # PATCH GENRE (cf routes)
  # def update_display
  #   # find the modified item from form2
  #   if session['g1_id']
  #     genre1 = Genre.find(session['g1_id'])
  #     genre1.update(name: genre_params[:name])
  #     session['g1_id']=nil
  #     redirect_to :root and return
  #   end
    

  #   # find the genre with id from form3 form last query string (written by hand)
  #   if session['g2_id']
  #     genre2 = Genre.find(session['g2_id'])
  #     genre2.update(name: genre_params[:name])
  #     session['g2_id']=nil
  #     redirect_to :root and return
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def genre_params
      params.require(:genre).permit(:name, :id)
    end

    def comment_params
      params.require(:comment).permit(:comment, :resto_id, :client_id, :client_new)
    end

    def resto_params
      params.require(:resto).permit(:name, :genre_id, :new_genre, genre_attributes: [:name])
    end
end
