module Api
  module V1
    class CommentsController < Api::BaseController

      # POST /api/v1/comments
      def create
        @comment = current_user.comments.build comment_params

        render json: {message: @comment.errors.full_messages}, 
          status: :unprocessable_entity and return if not @comment.save
      end

      private
        def comment_params
          params.require(:comment).permit(:text, :pin_id)
        end
        
    end # CommentsController
  end # V1
end # Api
