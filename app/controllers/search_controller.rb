class SearchController < ApplicationController

  DEFAULT_AUTOCOMPLETE_OPTIONS = {:limit => 10, :autocomplete => true}

  def index
    query = params[:query].blank? ? '*' : params[:query]

    @tags = current_user.owned_tags.alphabetical

    @users = UserDecorator.decorate_collection(User.search(query).reject { |user| user.invited_user? }).compact

    @pins = Pin.search(
              query,
              :where => {:user_id => current_user.friend_ids + [current_user.id]},
              :limit => 10,
              :autocomplete => true
            )

    @albums = @pins.map(&:album).uniq

    @hashtags = current_user.owned_tags.alphabetical.
                  where(
                    :id => Pin.search(
                            params[:query],
                            :limit => 10,
                            :autocomplete => true
                          ).map(&:tags).flatten.uniq.map(&:id)
                  )


  end



  def autocomplete
    users = User.search(
              params[:query],
              :limit => 10,
              :autocomplete => true
            ).reject { |user| user.invited_user? }.map(&:first_name).compact

    albums = Pin.search(
              params[:query],
              :limit => 10,
              :autocomplete => true,
              :where => {:user_id => current_user.friend_ids + [current_user.id]}
            ).map(&:album).uniq.map(&:title)


    pins = Pin.search(
            params[:query],
            :limit => 10,
            :autocomplete => true,
            :where => {:user_id => current_user.friend_ids + [current_user.id]}
          ).map(&:title)

    hashtags = current_user.owned_tags.alphabetical.
                where(
                  :id => Pin.search(
                          params[:query],
                          :limit => 10,
                          :autocomplete => true
                        ).map(&:tags).flatten.uniq.map(&:id)
                ).map(&:name)

    render :json => (users + albums + pins + hashtags)
  end


end
