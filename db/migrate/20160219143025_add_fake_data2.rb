class AddFakeData2 < ActiveRecord::Migration
  def change
    return unless Rails.env.development?
    Album.destroy_all
    Pin.destroy_all
    users = User.all
    users.each do |user|
      folder_path = "#{Rails.root.to_s}/public/BenPhoto"
      5.times.each do 
        album = Album.create! title: Forgery('lorem_ipsum').title, description: Forgery('lorem_ipsum').paragraph, user: user
        8.times do |i|
          album.pins.create! title: "#{i+1}-2.jpg", image: File.open("#{folder_path}/#{i+1}-2.jpg", 'rb'), description: Forgery('lorem_ipsum').paragraph
        end
      end
    end

  end
end
