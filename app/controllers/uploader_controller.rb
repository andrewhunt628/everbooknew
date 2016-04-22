# encoding: UTF-8
class UploaderController < ApplicationController

  # GET /uploader
  def index
    @albums = current_user.albums
    @pins = Pin.where(id: params[:pins])
  end

  # POST /uploader
  def upload
    # The upload is not multiple
    @pins = params[:files].map {|file|
      @pin = Pin.new
      @pin.image = file
      @pin.save
      @pin
    }

    respond_to do |format|
      format.json { render json: {pin: {
          id: @pin.id,
          url: @pin.image.url(:medium),
          title: @pin.image_file_name + ' – ' + (@pin.image_file_size.to_d / 1024).round(2).to_s + ' KB'
      }, status: :success}, status: :created }
    end
  end

  def finish
    @albums = current_user.albums
    @pins = Pin.where(id: params[:pins])
  end

  # POST /uploader/save
  def save
    if params[:newAlbum] == 'true'
      @user = current_user
      @album = @user.albums.create(title: params[:albumTitle], description: params[:albumDescription])
    else
      if params[:album]
        @album = current_user.albums.find(params[:album][:id])
      else
        @album = current_user.albums.new(title: 'New Album')
      end
    end

    @pins = params[:pins].map do |pin_params|
      pin = Pin.find pin_params[0]
      pin.title = pin_params[1]['title']
      pin.description = pin_params[1]['description']
      pin.tag_list = pin_params[1]['tag_list']
      pin.save
      pin
    end

    @pins.each do |pin|
      @album.pins << pin
      current_user.pins << pin
    end

    @album.save

    redirect_to '/albums'
  end

end