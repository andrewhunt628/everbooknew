class SearchController < ApplicationController


  def index
    @tags = current_user.owned_tags.alphabetical

    if params[:query].present?
      @users = UserDecorator.decorate_collection(User.search(params[:query]))
    end

  end


end
