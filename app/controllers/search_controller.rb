class SearchController < ApplicationController

  DEFAULT_AUTOCOMPLETE_OPTIONS = {:limit => 10, :autocomplete => true}

  def index
    query = params[:query].blank? ? '*' : params[:query]

    @tags = current_user.owned_tags.alphabetical

    @users = UserDecorator.decorate_collection(User.search(query).reject { |user| user.invited_user? }).compact

    @albums = Album.search(
                query,
                :where => {:user_id => current_user.friend_ids + [current_user.id]}
              )

    @pins = Pin.search(
              query,
              :where => {:user_id => current_user.friend_ids + [current_user.id]}
            )

    @hashtags = @tags.where(:id => ActsAsTaggableOn::Tag.search(query).map(&:id))

  end



  def autocomplete
    users = User.search(
              params[:query],
              :limit => 10,
              :autocomplete => true
            ).reject { |user| user.invited_user? }.map(&:first_name).compact

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

    hashtags = current_user.owned_tags.alphabetical.
                where(
                  :id => ActsAsTaggableOn::Tag.search(
                          params[:query],
                          :limit => 10,
                          :autocomplete => true
                        ).map(&:id)
                ).map(&:name)

    render :json => (users + albums + pins + hashtags)
  end


end
