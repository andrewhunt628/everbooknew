class FriendshipNotifications < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.friendship_notifications.new_invitation.subject
  #
  def new_invitation(from, to)
    
    @from = from
    @to = to

    @greeting = "Hi"

    mail to: to.email, subject: 'You have a new friend request on Kidio'
  end
end
