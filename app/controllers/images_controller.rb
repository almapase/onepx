class ImagesController < ApplicationController
  def index
  end

  def new
    @image = Image.new
  end

  # ANTES SE PODIA HACE ASÍ
  # def create
  #   @image = Image.new params[:image]
  # end

  def create
    @image = Image.new secure_params
    @image.save

    redirect_to images_path
  end

  private
  def secure_params
    params.require(:image).permit :name, :description, :category, :tags_text
  end
end
#index, show, new, create, edit, update, destroy
