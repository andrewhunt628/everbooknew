class FriendshipNotifications < ApplicationMailer

  layout 'friendship_mailer'


  def new_invitation inviter, invitee, url

    @inviter = inviter
    @invitee = invitee
    @base_url = url
    mail :to => @invitee.email,
         :subject => 'You have a new friend request on Kidio'
  end
end
