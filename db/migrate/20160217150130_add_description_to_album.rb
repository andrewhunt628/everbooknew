class AddDescriptionToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :description, :text
  end
end
