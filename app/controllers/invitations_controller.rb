class InvitationsController < ApplicationController

  def callback
    @contacts = request.env['omnicontacts.contacts']

    ContactsInviter.new(current_user, @contacts).send

    flash[:notice] = 'Invites successfully sent!'
    redirect_to new_user_invitation_path
  end


  def failure
    redirect_to new_user_invitation_path
  end

end
