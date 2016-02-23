class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build comment_params

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment, status: :created }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text, :pin_id)
    end
end
