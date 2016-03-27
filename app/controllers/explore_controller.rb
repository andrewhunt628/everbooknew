class ExploreController < ApplicationController

  def index
    @albums = Album.where(user_id: current_user.family_ids + [current_user.id])
                .order('albums.created_at DESC')

    @pins = @albums.reduce([]) {|n, album| album.pins + n}
                .sort_by!(&:updated_at).reverse!
    @tags = @albums.tag_counts_on(:tags)
  end

end