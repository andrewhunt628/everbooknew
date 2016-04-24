class FriendshipNotifications < ApplicationMailer

  def new_invitation inviter, invitee

    @inviter = inviter
    @invitee = invitee

    mail :to => @invitee.email,
         :subject => 'You have a new friend request on Kidio'
  end
end
