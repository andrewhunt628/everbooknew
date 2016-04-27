class TagsController < ApplicationController

  def show
    @tags = @tags = current_user.owned_tags.alphabetical
    @pins = Pin.tagged_with(params[:id], :owned_by => current_user).by_latest
  end


end
