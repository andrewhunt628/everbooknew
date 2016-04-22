# Preview all emails at http://localhost:3000/rails/mailers/friendship_notifications
class FriendshipNotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/friendship_notifications/new_invitation
  def new_invitation
    FriendshipNotifications.new_invitation
  end

end
