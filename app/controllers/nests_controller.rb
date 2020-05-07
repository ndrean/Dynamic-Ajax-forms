class NestsController < ApplicationController
  def new
    @resto = Resto.new
    @resto.comments.build
    #@resto.comments.build
  end

  def create
    logger.debug ".....................................CREATE ............."
    @resto = Resto.new(nest_params)
    if @resto.save
      redirect_to restos_path
    else
      render :new
    end
  end

  private
  def nest_params
      params.require(:resto).permit(:name, comments_attributes: [:id, :comment])
  end
end
