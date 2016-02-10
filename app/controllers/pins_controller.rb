class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!

	def index
		if params[:tag]
			@pins = Pin.tagged_with(params[:tag])
		else
			@pins = Pin.all
		end
		@pins = @pins.order("created_at DESC")
		render layout: 'index'
	end

	def show
	end

	def new
		@pin = current_user.pins.build
	end

	def edit
	end

	def destroy
		@pin.destroy
		redirect_to root_path
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin was Successfully updated!"
		else
			render 'edit'
		end
	end

	def create
		@pin = current_user.pins.build(pin_params)

		if @pin.save
			redirect_to @pin, notice: "Successfully created new Pin"
		else
			render 'new'
		end
	end

	private

	def pin_params
		@pin_params = params.require(:pin).permit(:title, :description, :image, :text_marks, :tag_list, :person_ids => [])
		@pin_params[:text_marks] = @pin_params[:text_marks].to_s.split(",").map(&:squish)
		@pin_params
	end

	def find_pin
		@pin = current_user.pins.find(params[:id])
	end

end
