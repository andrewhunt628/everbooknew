class AddAlbumToPin < ActiveRecord::Migration
  def change
    add_column :pins, :album_id, :integer
  end
end
