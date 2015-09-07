== README

Application OnePx made in the course of Ruby and rails on Platzi.com.
This this App emulates a little functionality of de site 500px.com

* Ruby version: 2.2.1

* System dependencies

* Configuration

* Database: PostgreSQL 9

* Server: Puma

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

This is the step by step of how this App was developed


Instalando Ruby on Rails
==============================================

Instalar RVM y Ruby a la vez:

    ~ curl -L https://get.rvm.io | bash -s stable --ruby

luego de instalar ejecutar la sigiente fuente:

    ~ source ~/.rvm/scripts/rvm

para revisar que ruby hay instalado:

    ~ rvm list

###Definimos el Gemset del proyecto
creamos el Gemset: *Gemset_onepx* en este caso, y le decimos que lo use todo en el mismo comando:

    ~ rvm use 2.2.1@Gemset_onepx --create

si solo quisieramos indicar que use cierto Gemset:

    ~ rvm 2.2.1@[Nombre del Gemset]

###Instalamos Rails en el proyecto
Instalamos la ultima version disponible:

    ~ gem install rails

para saber los gemset instalados:

    ~ rvm gemset list_all

---

#Creamos un nuevo proyecto llamado ONEPX será un clon de 500px.com
Nos unbicamos en el directorio que deceamos

    ~ cd onedrive/platzi/ror

ejecutamos el comando para crear una proyecto, en este caso indicando a postgresql como motror de base de datos:

    ~ rails new onepx -d postgresql

dio un error instalado pg -v 0.18.2, SOLUCIONAMOS EL ERROR COMO SIGUE:

    INSTALAMOS postgreSQL
    En la terminal ejecutamos:
    ~ gem install pg -- --with-pg-config=/Library/PostgreSQL/9.4/bin/pg_config

---
agregamos la siguiente dependencia en el archivo GemFile

    group :test do
      gem 'minitest-rails'
    end

agregamos al ambiente de desarrollo la dependencia

    gem 'pry-rails'
para actualizar las depencias, Corremos el comando:

    ~ bunble

nos muestra las tareas programadas en rails

    ~ rake -T

Usamos la primera tarea para crear la base de datos en el motor:

    ~ rake db:drop db:create db:migrate

El ultimo comando nos arroja el siguiente error:
*could not connect to server: No such file or directory*
SOLUCIONAMOS con los siguientes comandos:

    ~ sudo mkdir /var/pgsql_socket/
    ~ sudo ln -s /private/tmp/.s.PGSQL.5432 /var/pgsql_socket/

Volvemos a ejecutar:

    ~ rake db:drop db:create db:migrate

Otro error: faltan las password de Postgres

    en el archivo dataabse.yml
    agregamos ususrio y password
    a las bases de datos de desrrollo y de test

Error, al tratar de ver la vista en el browser:

    *AbstractController::Helpers::MissingHelperError in ImagesController#index*

Luego de investigar nos damos cuenta que es un error mayusculas iniciales en los nombres de las carpetas
si ejecutamos el *IRB* y corremos el comando:

    File.expand_path("./")
    => /Users/almapase/OneDrive/Platzi/ror/onepx

salimos de *IRB* y ejecutamos

    ~ pwd
    => /Users/almapase/onedrive/platzi/ror/onepx

SOLUCION, los dos comandos anteriores muestran la carpera ror en en minusculas pero en realidad es así: *RoR*:

    ~ cd onedrive/platzi
    ~ mv RoR ror

---
#Activar HSTORE en PosgreSQL
para eso haremos una migración

    ~ rails g migration add_hstore

Esto nos genera un rarchivo *20150830162955_add_hstore.rb* en el directorio => db/migrate
El archivo debe tener el siguiente codigo:

    class AddHstore < ActiveRecord::Migration
        def up
            enable_extension :hstore
        end

        def down
            disable_extension :hstore
        end
    end

En la consola aplicamos la migración

    ~ rake db:migrate

#Generaremos nuestro modelo usando las migraciones y el patron ACTIVE_RECORD
gereramos el modelo

    ~rails g model image name category:integer description:text tags

Nos generá un archivo en la carpeta => db/migrate, lo dejamos con el siguiente condigo:

    class CreateImages < ActiveRecord::Migration
      def change
        create_table :images do |t|
          t.string :name, null: false
          t.integer :category, default: 0
          t.text :description
          t.string :tags, array: true, default: []

          t.timestamps null: false
        end
      end
    end

Hora ejecutamos la migración:

    ~ rake db:migrate
    == 20150830164618 CreateImages: migrating =====================================
    -- create_table(:images)
       -> 0.0942s
    == 20150830164618 CreateImages: migrated (0.0943s) ============================

---
#Ahora trabajaremos con nuestro modelo
en el archivo *image.rb* colocamos el siguente codigo, que nos permitira darle nombre a las categorias
por medio de un *enumerable*

    class Image < ActiveRecord::Base
      enum category: %w(portrait landscape city\ exploration nature animals)
    end

Ahora trabajaremos en la consola de Rails, para eso ejecutamos:

    ~ rails c

Nos queda el siguiente pront (pry biene de una gema pryrails que decora el codigo de la consola de Rails:

    Loading development environment (Rails 4.2.4)
    [1] pry(main)>

Para interrumpir un proceso en ejecución dentro de la consola:

    Ctrl-C

Para salir de la consola en sí,

    Ctrl-D

Si en la consola de Rails ejecutamos, para saber cuantos registros tiene la tabla images

    > Image.cout
    (8.0ms)  SELECT COUNT(*) FROM "images"
    => 0

para que retorne todos los registros

    pry(main)> Image.all
    Image Load (5.2ms)  SELECT "images".* FROM "images"
    => []

Podemos crear un nuevo registro por medio de la consola de rails de la siguiente forma:

    [5] pry(main)> i = Image.new
    => #<Image:0x007fa54a43d6d0 id: nil, name: nil, category: 0, description: nil, tags: [], created_at: nil, updated_at: nil>

    [6] pry(main)> i.name = 'Ciudad de Santiago'
    => "Ciudad de Santiago"

    [7] pry(main)> i.description = 'Día lluvioso'
    => "Día lluvioso"

    [8] pry(main)> i.category = "city \ exploration"
    ArgumentError: 'city  exploration' is not a valid category
    from /Users/almapase/.rvm/gems/ruby-2.2.1@Gemset_onepx/gems/activerecord-4.2.4/lib/active_record/enum.rb:105:in `block (3 levels) in enum'

    [9] pry(main)> i.category = "city\ exploration"
    => "city exploration"

    [10] pry(main)> i.tags = %w(santiago cuidad calles lluvia)
    => ["santiago", "cuidad", "calles", "lluvia"]

    [11] pry(main)> i
    => #<Image:0x007fa54a43d6d0
     id: nil,
     name: "Ciudad de Santiago",
     category: 2,
     description: "Día lluvioso",
     tags: ["santiago", "cuidad", "calles", "lluvia"],
     created_at: nil,
     updated_at: nil>

    [12] pry(main)> i.save
       (2.5ms)  BEGIN
      SQL (37.8ms)  INSERT INTO "images" ("name", "description", "category", "tags", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["name", "Ciudad de Santiago"], ["description", "Día lluvioso"], ["category", 2], ["tags", "{santiago,cuidad,calles,lluvia}"], ["created_at", "2015-08-30 22:58:12.094602"], ["updated_at", "2015-08-30 22:58:12.094602"]]
       (27.9ms)  COMMIT
    => true


Ahora podemos consultar el objeto *i* enlazado al regustro de la base de datos

    [13] pry(main)> i
    => #<Image:0x007fa54a43d6d0
     id: 1,
     name: "Ciudad de Santiago",
     category: 2,
     description: "Día lluvioso",
     tags: ["santiago", "cuidad", "calles", "lluvia"],
     created_at: Sun, 30 Aug 2015 22:58:12 UTC +00:00,
     updated_at: Sun, 30 Aug 2015 22:58:12 UTC +00:00>

Buscar dentro de la tabla imagenes los registros que contegan *lluv* dentro de la descripción

    [15] pry(main)> Image.where("description LIKE ?", "%lluv%")
      Image Load (22.1ms)  SELECT "images".* FROM "images" WHERE (description LIKE '%lluv%')
    => [#<Image:0x007fa54e079a68
      id: 1,
      name: "Ciudad de Santiago",
      category: 2,
      description: "Día lluvioso",
      tags: ["santiago", "cuidad", "calles", "lluvia"],
      created_at: Sun, 30 Aug 2015 22:58:12 UTC +00:00,
      updated_at: Sun, 30 Aug 2015 22:58:12 UTC +00:00>]

Con esta centencia EXCLUSIVA DE PosgreSQL buscamos dentro del array del campo *tags*

    [16] pry(main)> Image.where("? = ANY(tags)", "calles")
      Image Load (15.2ms)  SELECT "images".* FROM "images" WHERE ('calles' = ANY(tags))
    => [#<Image:0x007fa54e1c9da0
      id: 1,
      name: "Ciudad de Santiago",
      category: 2,
      description: "Día lluvioso",
      tags: ["santiago", "cuidad", "calles", "lluvia"],
      created_at: Sun, 30 Aug 2015 22:58:12 UTC +00:00,
      updated_at: Sun, 30 Aug 2015 22:58:12 UTC +00:00>]

Todos los metodos diponibles para *Image*

    [17] pry(main)> Image.instance_methods
    => [:category=,
     :category,
     :category_before_type_cast,
     :portrait?,
     :portrait!,
     :landscape?,
     :landscape!,
     :"city exploration?",
     :"city exploration!",
     :nature?,
     :nature!,
     :animals?,
     :animals!,
     :id,
     :id=,
     :id_before_type_cast,
     :id_came_from_user?,
     :id?,
     :id_changed?,
     :id_change,
     :id_will_change!,
     :id_was,
     :reset_id!,
     :restore_id!,
     :name,
     :name=,
     :name_before_type_cast,
     :name_came_from_user?,
     :name?,
     :name_changed?,
     :name_change,
     :name_will_change!,
     :name_was,
     :reset_name!,
     :restore_name!,
     :category_came_from_user?,

#Ahora conectaremos el patron MVC
Si cerramos la consola debemos asegurarnos que usemos el GemSet correcto, cuando uasamos RVM

    ~/onedrive/platzi/ror/onepx(image-management ✗) rvm list gemsets

    rvm gemsets

    => ruby-2.2.1 [ x86_64 ]
       ruby-2.2.1@Gemset_onepx [ x86_64 ]
       ruby-2.2.1@global [ x86_64 ]

    ~/onedrive/platzi/ror/onepx(image-management ✗) rvm use ruby-2.2.1@Gemset_onepx
    Using /Users/almapase/.rvm/gems/ruby-2.2.1 with gemset Gemset_onepx


#Validando datos del formulario
agregamos la siguiente linea en el archivo *image.rb* justo antes de la ¡s definiciones de metodos

    validates :name, presence: true # name tiene que ser requerido

en el archivo *images_controller.rb* modoficamos el metodo *create*

    def create
        @image = Image.new secure_params

        #Pregunta si no hay errores al guardar
        if @image.save
          return redirect_to images_path, notice: t('.created', model: @image.class.model_name.human)
          #notice captura cuando algo sucedio bien, usando flash registro de llave, valor
        end

        render :new # me vuelve a mostrar la pagina de NEW manteniendo los datos
    end

En la carpeta *lib* creamos un archivo llamado *custom_form_builder.rb* con el siguuente contenido

    class CustomFormBuilder < ActionView::Helpers::FormBuilder
        def form_error
            if self.object.errors.any?
              plural_name = self.object.class.model_name.plural
              model_name = self.object.class.model_name.human
              is_new = self.object.persisted? ? 'edit' : 'new'

              @template.content_tag :div, class: 'form-error' do
                @template.content_tag :p, I18n.t("#{plural_name}.#{is_new}.form.error", model: model_name)
              end
            end
            end

            def field_error(method)
            if self.object.errors[method].any?
              @template.content_tag :span, self.object.errors[method].first, class: 'field_error'
            end
        end
    end

En el archivo *config/application.rb* agregar la siguiente linea:

    #Al arranar la aplicacion carge los archivos que estan el siguinte  directorio
    config.autoload_paths += %W(#{config.root}/lib)

En el archivo *new.html.rb* modoficamos como sigue:

    <%= form_for @image, builder: CustomFormBuilder do |form| %>
      <%= form.form_error %>

      <div class="field">
        <%= form.label :name %>
        <%= form.text_field :name %>
        <%= form.field_error :name %>

En el archivo *app/views/layouts/application.html.erb* y agregamos el siguiente codigo en el <body>

      <div id="flash">
        <% flash.each do |key, value| -%>
          <div id="flash-<%= key %>">
            <%= value %>
          </div>
        <% end -%>
      </div>

#Optimiza para un listado de imágenes
modificamos el INDEX del archivo *images_controler.rb*

    def index
        @images = Image.all #TODO paginacion con KAMINARY
      end

modifificamos el *index.html.erb*

    <section class="images">
      <%= render @images %>
    </section>

Creamos una vista partcial *_image.html.erb*

    <div class="image-box">
      <div class="image-content">
        <h2><%= image.name %></h2>
      </div>
    </div>

#Creando nuestro archivo CSS
Agregamos el archivo *app/assets/stylesheets/images.acss*

#Configurar Carrierwave
CarrierWave es una gema para cargar imagenes
en el archivo *Gemfile* agregamos:

```
gem 'carrierwave'
```
tambien agregamos la gema
```
gem 'mini_magick'
```
esta gema sirve trabajar con la libreria *ImageMagick*, carrierwave
utiliza ArcMagick para crear diferentes tamaños de una imagen.
ArcMagick es una libreia escrita en C.

Despues de ejecutar *bunble* para actualizar las gemas, ejecutamos:
```
rails g
```
y revisamos que el generador *uploader* este en el listado de generadores

para crear un archivo de configuración de *carrierwave* ejecutamos
lo siguiente:
```
~ rails g uploader Photo

RESULTADO:
  create  app/uploaders/photo_uploader.rb
```
en el archivo creado descomentamos:
```
include CarrierWave::MiniMagick
```
para definir una imagen por defecto utilizamos la siguiente funcion:
```
def default_url
    ActionController::Base.helpers.asset_path("default.png")
end
```
para definir las extensiones por defecto utilizamos la funcion:
```
def extension_white_list
  %w(jpg jpeg gif png)
end
```
para crear diferentes versiones, lo hacemos así
```
version :medium do
  process :resize_to_fill => [850, 850]
end

version :thumb do
  process :resize_to_fill => [250, 250]
end
```
Ahora vamos al modelo de Image y agregamos la referencia para carrierwave
```
mount_uploader :photo, PhotoUploader
```
Ahora debemos agregar el atributo photo a la base de datos, para esto generamos la siguiente migración:
```
~ rails g migration add_photo_to_images photo
```
nos genera la siguiente migracion:
```
class AddPhotoToImages < ActiveRecord::Migration
  def change
    add_column :images, :photo, :string
  end
end
```
Ejecutamos la migración:
```
~ rake db:migrate
```
para mostrar las imagenes modificamos la vista  parcial de image.
```
<%= image_tag image.photo.thumb.url %>
```
Ahora modificaremos el formulario para cargar una imagen
```
<div class="field">
  <%= form.label :photo %>
  <%= form.file_field :photo %>
</div>
```
En el ocntrolador agregamos photo a los parametros permitidos:
```
def secure_params
  params.require(:image).permit :name, :description, :category, :tags_text,
    :photo
end
```
Ahora instalamos *ImageMagick* aquí instrucciones: http://www.imagemagick.org/script/binary-releases.php
```
~ brew install ImageMagick

RESULTADO:
==> Installing dependencies for imagemagick: xz, jpeg, libpng, libtiff, freetype
==> Installing imagemagick dependency: xz
==> Downloading https://homebrew.bintray.com/bottles/xz-5.2.1.yosemite.bottle.tar.gz
######################################################################## 100.0%
==> Pouring xz-5.2.1.yosemite.bottle.tar.gz
🍺  /usr/local/Cellar/xz/5.2.1: 59 files, 1.7M
==> Installing imagemagick dependency: jpeg
==> Downloading https://homebrew.bintray.com/bottles/jpeg-8d.yosemite.bottle.2.tar.gz
######################################################################## 100.0%
==> Pouring jpeg-8d.yosemite.bottle.2.tar.gz
🍺  /usr/local/Cellar/jpeg/8d: 18 files, 776K
==> Installing imagemagick dependency: libpng
==> Downloading https://homebrew.bintray.com/bottles/libpng-1.6.18.yosemite.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libpng-1.6.18.yosemite.bottle.tar.gz
🍺  /usr/local/Cellar/libpng/1.6.18: 17 files, 1.2M
==> Installing imagemagick dependency: libtiff
==> Downloading https://homebrew.bintray.com/bottles/libtiff-4.0.4.yosemite.bottle.tar.gz
######################################################################## 100.0%
==> Pouring libtiff-4.0.4.yosemite.bottle.tar.gz
🍺  /usr/local/Cellar/libtiff/4.0.4: 257 files, 3.9M
==> Installing imagemagick dependency: freetype
==> Downloading https://homebrew.bintray.com/bottles/freetype-2.6_1.yosemite.bottle.tar.gz
######################################################################## 100.0%
==> Pouring freetype-2.6_1.yosemite.bottle.tar.gz
🍺  /usr/local/Cellar/freetype/2.6_1: 60 files, 2.6M
==> Installing imagemagick
==> Downloading https://homebrew.bintray.com/bottles/imagemagick-6.9.1-10.yosemite.bottle.tar.gz
######################################################################## 100.0%
==> Pouring imagemagick-6.9.1-10.yosemite.bottle.tar.gz
🍺  /usr/local/Cellar/imagemagick/6.9.1-10: 1447 files, 22M
```
