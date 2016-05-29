class SearchController < ApplicationController

  DEFAULT_AUTOCOMPLETE_OPTIONS = {:limit => 10, :autocomplete => true}

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
    users = User.search(params[:query], DEFAULT_AUTOCOMPLETE_OPTIONS).map(&:first_name)
    albums = Album.search(params[:query], DEFAULT_AUTOCOMPLETE_OPTIONS).map(&:title)

    render :json => (users + albums)
  end


end
