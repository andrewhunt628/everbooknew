class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!
	helper_method :tags_list

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

    respond_to do |format|
      if @pin.save
        format.json { render json: @pin, status: :created, location: @pin }
      else
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
	end

	private

		def tags_list
			params[:tags_list].to_s.split("/")
		end

		def pin_params
			@pin_params = params.require(:pin).permit(:title, :description, :image, :text_marks, :tag_list, :person_ids => [])
			@pin_params[:text_marks] = @pin_params[:text_marks].to_s.split(",").map(&:squish)
			@pin_params
		end

		def find_pin
			@pin = current_user.pins.find(params[:id])
		end

end
