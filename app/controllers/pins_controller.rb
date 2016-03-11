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

  def destroy
    @pin.destroy
    redirect_to root_path
  end

  def edit
    
  end

  def update
    if @pin.update(pin_params)
      redirect_to pins_path, notice: "Pin was Successfully updated!"
    else
      render 'edit'
    end
  end

  def new
    @pin = current_user.pins.build
  end

  def uploading#tmp method for demostration
    
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
