class NestsController < ApplicationController
  
  def new
    # first form in the view 'new'
    @genre = Genre.new
    @genre.restos.build.comments.build

    # second form in the view 'new'
    @resto = Resto.new
    @resto.comments.build
    #@resto.comments.build
  end

  def createNested
    @genre = Genre.new(nest_params)
    if @genre.save
      redirect_to restos_path
    else
      render :new
    end
  end

  def createDyn
    @resto = Resto.new(resto_params)
    if @resto.save
      redirect_to restos_path
    else
      render :new
    end
  end

  private
  def nest_params
    params.require(:genre).permit(:name,
       restos_attributes: [:name,
         comments_attributes:[:comment]])
  end

  def resto_params
    params.require(:resto).permit(:name, :genre_id, comments_attributes: [:id, :comment])
  end

end
