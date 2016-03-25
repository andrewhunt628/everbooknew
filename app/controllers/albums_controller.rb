class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.where(user_id: current_user.family_ids + [current_user.id])
    if tags_list.present?
      @albums = @albums.tagged_with(tags_list.split("/"))
    end
    @albums = @albums.order("albums.created_at DESC")
    @tags = @albums.tag_counts_on(:tags)
    @pins = @albums.reduce([]) {|n, album| album.pins + n}
    @pins.sort_by!(&:updated_at).reverse!
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @albums = current_user.albums
    @pins = Pin.where(id: params[:pins])
  end

  def uploader
    @albums = current_user.albums
    @pins = Pin.where(id: params[:pins])
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums/quickupload
  def quick_upload
    @pins = params[:files].map {|file|
      @pin = Pin.new
      @pin.image = file
      @pin.save
      @pin
    }

    respond_to do |format|
      format.json { render json: {pins: @pins.map(&:id), status: :success}, status: :created }
    end
  end

  # POST /albums/quickupload/save
  def quick_upload_save
    if params[:newAlbum] == 'true'
      @user = current_user
      @album = @user.albums.create(title: params[:title], description: params[:description])
    else
      @album = current_user.albums.find(params[:album][:id])
    end

    @pins = Pin.where(id: params[:pins].split(','))
    @pins.each do |pin|
      @album.pins << pin
      current_user.pins << pin
    end

    @album.save

    redirect_to '/albums'
  end

  # POST /albums
  # POST /albums.json
  def create

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = current_user.albums.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:title, :description, :tag_list, :pins_attributes => [:id, :title, :description, :image, :_destroy, :text_marks, :person_ids])
    end
end
