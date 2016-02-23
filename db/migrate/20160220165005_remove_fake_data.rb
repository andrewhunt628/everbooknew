class RemoveFakeData < ActiveRecord::Migration
  def change
    unless Rails.env.production?
      Album.delete_all
      Pin.delete_all
    end
  end
end
