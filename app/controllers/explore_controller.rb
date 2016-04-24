class ExploreController < ApplicationController

  def index
    @tags = current_user.owned_tags.alphabetical

    @users = User.all_except(current_user).decorate
  end

end
