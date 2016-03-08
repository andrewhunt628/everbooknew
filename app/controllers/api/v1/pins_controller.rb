module Api
  module V1
    class PinsController < Api::BaseController
      before_action :find_pin, only: [:show, :update, :destroy]

      # GET /api/v1/pins
      def index
        if tags_list.present?
          @pins = current_user.pins.tagged_with(tags_list.split("/"))
        else
          @pins = current_user.pins
        end
        @pins = @pins.order("pins.created_at DESC")
        @tags = @pins.tag_counts_on(:tags)  
      end

      # GET /api/v1/pins/:id
      def show
        @pin  = Pin.find(params[:id])
      end

      # PUT /api/v1/pins/:id
      def update
        render json: {message: @pin.errors.full_messages}, status: :unprocessable_entity and return if not @pin.update(pin_params)
      end

      # POST /api/v1/pins
      def create
        @pin = Pin.new(pin_params)

        render json: {message: @pin.errors.full_messages}, status: :unprocessable_entity and return if not @pin.save
      end

      # DELETE /api/v1/pins/:id
      def destroy
        render json: {message: @pin.errors.full_messages}, 
          status: :unprocessable_entity and return if not @pin.destroy
        
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

    end # PinsController
  end # V1
end # Api
