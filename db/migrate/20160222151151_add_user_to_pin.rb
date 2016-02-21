class AddUserToPin < ActiveRecord::Migration
  def change
    add_column :pins, :user_id, :integer
    Pin.all.each do |pin|
      pin.user_id = pin.album.user_id
      pin.save!
    end
  end
end
