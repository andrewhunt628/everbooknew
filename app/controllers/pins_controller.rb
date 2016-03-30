class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    if tags_list.present?
      @pins = current_user.pins.tagged_with(tags_list.split("/"))
    else
      @pins = current_user.pins
    end
    @pins = @pins.order("pins.created_at DESC")
    @tags = @pins.tag_counts_on(:tags)  
  end


  def show
    render :show, layout: false 
  end

  def remove_tag
    @pin = Pin.find params[:id]
    @pin.tag_list.remove(params[:tag])

    respond_to do |format|
      if @pin.save
        format.json {render json: {status: :ok, location: @pin}}
        format.html {redirect_to @pin, notice: 'Tag was successfully removed.'}
      else
        format.json {render json: @pin.errors, status: :unprocessable_entity}
        format.html {redirect_to :edit}
      end
    end
  end

  def destroy
    @pin.destroy

    respond_to do |format|
      format.json { render json: {status: :ok } }
      format.html { redirect_to root_path }
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @pin.update(pin_params)
        format.html { redirect_to @pin, notice: "Pin was Successfully updated!" }
        format.json { render json: {status: :ok, location: @pin}}
      else
        format.html { render 'edit' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @pin = current_user.pins.build
  end

  def create
    @pin = Pin.new(pin_params)

    respond_to do |format|
      if @pin.save
        format.json { render json: @pin, status: :created, location: @pin }
        format.html { redirect_to pins_path }
      else
        format.json { render json: @pin.errors, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
  end

  private

    def pin_params
      @pin_params = params.require(:pin).permit(:title, :description, :image, :text_marks, :tag_list, :album_id, :person_ids => [])
      @pin_params[:text_marks] = @pin_params[:text_marks].to_s.split(",").map(&:squish)
      @pin_params.merge(user_id: current_user.id)
    end

    def find_pin
      @pin = Pin.all.find(params[:id])
    end

end
