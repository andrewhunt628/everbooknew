class AddFakeData < ActiveRecord::Migration
  def change
    return unless Rails.env.development?
    users = User.all
    users.each do |user|
      10.times do
        u = FactoryGirl.create(:user)
        user.add_family_member(u)
      end

      folder_path = "#{Rails.root.to_s}/public/BenPhoto"

      8.times do |i|
        Pin.create(title: "#{i+1}-2.jpg", image: File.open("#{folder_path}/#{i+1}-2.jpg", 'rb'), user: user)
      end
    end

  end
end
