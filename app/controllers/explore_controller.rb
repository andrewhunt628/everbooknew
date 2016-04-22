class ExploreController < ApplicationController

  def index
    @albums = Album.where(user_id: current_user.family_ids + [current_user.id])
                .order('albums.created_at DESC')

    @pins = @albums.reduce([]) {|n, album| album.pins + n}
                .sort_by!(&:updated_at).reverse!
    @tags = @albums.tag_counts_on(:tags)
    @users = User.all
  end

  def add_friendship
  	@friendship_user = User.find(params[:friend_id])
  	current_user.invite @friendship_user
  	FriendshipNotifications.new_invitation(current_user, @friendship_user).deliver_now
  	flash[:notice] = "An invite was sent to #{@friendship_user.first_name} #{@friendship_user.last_name}"
  	redirect_to action: "index"
  end

end