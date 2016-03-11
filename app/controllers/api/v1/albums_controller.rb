module Api
  module V1
    class AlbumsController < Api::BaseController
      before_action :set_album, only: [:show, :edit, :update, :destroy]
      
      # GET /api/v1/albums
      def index
        @albums = Album.where(user_id: current_user.family_ids + [current_user.id])
        if tags_list.present?
          @albums = @albums.tagged_with(tags_list.split("/"))
        end
        @albums = @albums.order("albums.created_at DESC")
        @tags = @albums.tag_counts_on(:tags)
      end

      # GET /api/v1/albums/:id
      def show
        
      end

      # POST /api/v1/albums
      def create
        @album = current_user.albums.new(album_params)

        render json: {message: @album.errors.full_messages}, 
          status: :unprocessable_entity and return if not @album.save
      end

      # PUT /api/v1/albums/:id
      def update
        render json: {message: @album.errors.full_messages}, 
          status: :unprocessable_entity and return if not @album.update(album_params)
      end

      # DELETE /api/v1/albums/:id
      def destroy
        render json: {message: @album.errors.full_messages}, 
          status: :unprocessable_entity and return if not @album.destroy
        
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
    end # AlbumsController
  end # V1
end # Api
