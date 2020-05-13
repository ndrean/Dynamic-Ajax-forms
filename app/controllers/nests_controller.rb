class NestsController < ApplicationController
  
  def new
    @genre = Genre.new
    @genre.restos.build.comments.build
  end

  def create
    @genre = Genre.new(nest_params)
    if @genre.save
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
end
