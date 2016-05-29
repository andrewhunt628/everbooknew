class SearchController < ApplicationController


  def index
    @tags = current_user.owned_tags.alphabetical

    if params[:query].present?
      @users = UserDecorator.decorate_collection(User.search(params[:query]))
      @albums =
        Album.search(
          params[:query],
          :where => {:user_id => current_user.friend_ids + [current_user.id]}
        )
    end

  end



  def autocomplete
    render :json => User.search(params[:query], :autocomplete => true, :limit => 10).map(&:first_name)
  end


end
