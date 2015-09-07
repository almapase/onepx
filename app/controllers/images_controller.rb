class ImagesController < ApplicationController
  def index
    @images = Image.all #TODO paginacion con KAMINARY
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new secure_params

    #Pregunta si no hay errores al guardar
    if @image.save
      return redirect_to images_path, notice: t('.created', model: @image.class.model_name.human)
      #notice captura cuando algo sucedio bien, usando flash registro de llave, valor
    end

    render :new # me vuelve a mostrar la pagina de NEW manteniendo los datos
  end

  private
  def secure_params
    params.require(:image).permit :name, :description, :category, :tags_text,
      :photo
  end
end
