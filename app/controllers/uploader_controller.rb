class UploaderController < ApplicationController

  # GET /uploader
  def index
    @albums = current_user.albums
    @pins = Pin.where(id: params[:pins])
  end

  # POST /uploader
  def upload
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

  def finish
    @albums = current_user.albums
    @pins = Pin.where(id: params[:pins])
  end

  # POST /uploader/save
  def save
    print params

    # if params[:newAlbum] == 'true'
    #   @user = current_user
    #   @album = @user.albums.create(title: params[:title], description: params[:description])
    # else
    #   @album = current_user.albums.find(params[:album][:id])
    # end
    #
    # @pins = Pin.where(id: params[:pins].split(','))
    # @pins.each do |pin|
    #   @album.pins << pin
    #   current_user.pins << pin
    # end
    #
    # @album.save
    #
    redirect_to '/albums'
  end

end