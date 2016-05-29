class SearchController < ApplicationController

  DEFAULT_AUTOCOMPLETE_OPTIONS = {:limit => 10, :autocomplete => true}

  def index
    query = params[:query].blank? ? '*' : params[:query]

    @tags = current_user.owned_tags.alphabetical

    @users = UserDecorator.decorate_collection(User.search(query))

    @albums = Album.search(
                query,
                :where => {:user_id => current_user.friend_ids + [current_user.id]}
              )

    @pins = Pin.search(
              query,
              :where => {:user_id => current_user.friend_ids + [current_user.id]}
            )


  end



  def autocomplete
    users = User.search(
              params[:query],
              :limit => 10,
              :autocomplete => true
            ).map(&:first_name)

    albums = Album.search(
              params[:query],
              :limit => 10,
              :autocomplete => true,
              :where => {:user_id => current_user.friend_ids + [current_user.id]}
            ).map(&:title)


    pins = Pin.search(
            params[:query],
            :limit => 10,
            :autocomplete => true,
            :where => {:user_id => current_user.friend_ids + [current_user.id]}
          ).map(&:title)


    render :json => (users + albums + pins)
  end


end
